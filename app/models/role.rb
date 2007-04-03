# == Schema Information
# Schema version: 123
#
# Table name: roles
#
#  id              :integer(11)   not null, primary keyreflection
#  name            :string(255)   default(), not null
#  parent_id       :integer(11)   
#  description     :string(1024)  default(), not null
#  default_page_id :integer(11)   
#  cache           :text          
#  created_at      :timestamp     
#  updated_at      :timestamp     
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class Role < ActiveRecord::Base
  cattr_accessor :cached_methods
  cattr_accessor :cached_models
  cattr_accessor :cached_controllers
  

  serialize :cache

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :description

  has_many :permissions, :class_name=>'RolePermission',:include=>'permission'

 
##
# Subjects
# 
 def subjects
   rebuild unless cache
   cache.keys 
 end

##
#Actions for a given subject
# 
 def actions(subject)
   rebuild unless cache
   cache[subject].keys   
 end
  
##
# List of possible actions for over all controller
#  
 def possible_actions
   all = []
   for subject in subjects
     all << cache[subject].keys
     all = all.uniq
   end
   return all
 end



##
# Get a permission for a subject and actions
#   
 def allow?(subject,action)
   rebuild if self.cache.nil?
   return !( self.cache[subject.to_s].nil? or self.cache[subject.to_s][action.to_s].nil?)
 end
  
#Grant access 
# 
 def grant(subject,action)
   rebuild  if self.cache.nil?
    unless allow?(subject,action)
       permission = self.permissions.create(:subject=>subject.to_s,:action=>action.to_s)
       self.cache ||= Hash.new
       self.cache[subject.to_s] ||= Hash.new
       self.cache[subject.to_s][action.to_s] = true
       return true
    end    
    return false
 end

##
# Deny access
#  
 def deny(subject,action)
    rebuild if self.cache.nil?
    item = RolePermission.find(:first,:conditions=>['role_id=? and subject=? and action=?',id,subject.to_s,action.to_s])
    if item
       item.destroy 
       self.cache[subject.to_s][action.to_s]=nil
       return true
    end
    return false
 end

##
# Redo the  
 def reset_rights(rights)
   for subject in Role.controllers.keys
     for action in Role.methods(subject)
       if rights[subject] and rights[subject][action]
          grant(subject,action)
       elsif allow?(subject,action)
          deny(subject,action)
       end
     end
   end
  rebuild
 end

##
# Grant all rights to a array of subjects
# 
 def grant_all(subjects = nil)
   subjects = Role.controllers.keys unless subjects
   for subject in subjects
     for action in Role.methods(subject)
        grant(subject,action)
     end
   end
   self.save   
 end

##
# deny access to a list of subjects all methods will be denied
# 
 def deny_all(subjects = nil)
   subjects = Role.controllers.keys unless subjects
   for subject in subjects
     for action in Role.methods(subject)
        deny(subject,action)
     end
   end
   self.save   
 end

##
# Rebuild the cache
#   
 def rebuild
     logger.info "rebuild rights cache"
     self.cache= Hash.new
     for item in permissions
        self.cache[item.subject.to_s] ||= Hash.new
        self.cache[item.subject.to_s][item.action.to_s] = true
     end          
     self.save
 end

  
##
# Build the cache of all the menus and rights for roles
# 
  def Role.rebuild_cache
	 for role in Role.find(:all)  
        role.cache = nil ; 
        role.rebuild
 	 end     
  end

##
# Force a reload of all the controllers,models,methods and cache infomation
# 
  def Role.reload
     @@cached_models =nil	   
     @@cached_controllers =nil	   
     @@cached_methods =nil
     Role.rebuild_cache	   
  end

##
# Get a List of all the Models
#   
  def Role.models
    unless @@cached_models and @@cached_models.size>1
      logger.info "Reloading Role.models"
      for file in Dir.glob("#{RAILS_ROOT}/app/models/*.rb") do
        begin
          load file
        rescue
          logger.info "Couldn't load file '#{file}' (already loaded?)"
        end
      end  
      @@cached_models = []
  
      ObjectSpace.each_object(Class) do |klass|
        if klass.ancestors.any?{|item|item==ActiveRecord::Base} and !klass.abstract_class
          @@cached_models << klass unless @@cached_models.any?{|item|item.to_s == klass.to_s}
        end
      end
  
      @@cached_models -= [ActiveRecord::Base, CGI::Session::ActiveRecordStore::Session]
      @@cached_models = @@cached_models.sort{|a,b| a.to_s <=> b.to_s }
    end
    return @@cached_models
  end
  
##
#List all the controllers 
#  
 def Role.controllers
    unless @@cached_controllers and  @@cached_controllers.size>1  
      logger.info "Reloading   Role.controllers"
      rbfiles = File.join("#{RAILS_ROOT}/app/controllers/**", "*.rb")  
      for file in Dir.glob(rbfiles) do
        begin
          load file
        rescue
          logger.debug "Couldn't load file '#{file}' (already loaded?)"
        end
      end
      @@cached_controllers = Hash.new    
      ObjectSpace.each_object(Class) do |klass|
        if klass.respond_to? :controller_name
            if klass.superclass.to_s == ApplicationController.to_s
              @@cached_controllers[klass.controller_name] = klass
            end
        end
      end
    end    
    return @@cached_controllers
 end

##
# Get a list of all actions types defined in tyhe current system  
# 
  def Role.all_methods
    unless @@cached_methods and @@cached_methods.size>0
        logger.info "Reloading  Role.all_methods"
        @@cached_methods = []
        for controller in Role.controllers.values
            @@cached_methods << controller.public_instance_methods - ApplicationController.public_instance_methods  
        end  
        @@cached_methods = @@cached_methods.flatten.uniq
        return @@cached_methods
    end 
  end  
##
# get the list of possible actions for this controller
# 
  def Role.methods(controller)
    if controller.class == String
        controller = Role.controller(controller)
    end
    methods = controller.public_instance_methods - ApplicationController.public_instance_methods
    return methods
  end
  
  def Role.possible(subject,action)
      Role.methods(subject).detect{|i|i==action.to_s}
  end

##
#Convert a subject to a controller in the correct namespace
#
  def Role.controller(subject)
     controller = Role.controllers[subject]
     unless controller
          controller = eval("#{controller}_controller".camelcase)
     end
     return controller      
  end


end
