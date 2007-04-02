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

  serialize :cache

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :description

  has_many :items, :class_name=>'Permission'

 
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
   if cache
      puts "using cache"
      return (cache[subject] and cache[subject][action])
   else
      puts "allows(#{subject},#{action}) "
      return permissions.detect{ |item| item.subject ==subject.to_s and item.action==action.to_s}
   end
 end
  
#Grant access 
# 
 def grant(subject,action)
    unless allow?(subject,action)
       self.permissions.create(:subject=>subject.to_s,:action=>action.to_d)
       rebuild
    end
 end

##
# Deny access
#  
 def deny(subject,action)
    item = Permission.find(:first,:conditions=>['role_id=? and subject=? and action=?',id,subject,action])
    if item
       item.destroy 
       rebuild
    end
 end

  
##
# Build the cache of all the menus and rights for roles
# 
  def Role.rebuild_cache	   
	 for role in Role.find(:all)  
        role.rebuild
 	 end     
  end

  def rebuild
     self.cache = nil ; 
     self.save # we have to do this to clear it
     self.cache = Hash.new
     for item in permissions
        cache[item.subject] ||= Hash.new
        cache[item.subject][item.action] = true
     end          
     self.save
  end

##
# Get a List of all the Models
#   
  def models
    unless @models
      for file in Dir.glob("#{RAILS_ROOT}/app/models/*.rb") do
        begin
          load file
        rescue
          logger.info "Couldn't load file '#{file}' (already loaded?)"
        end
      end  
    end
    @models = []

    ObjectSpace.each_object(Class) do |klass|
      if klass.ancestors.any?{|item|item==ActiveRecord::Base} and !klass.abstract_class
        @models << klass unless @models.any?{|item|item.to_s == klass.to_s}
      end
    end

    @models -= [ActiveRecord::Base, CGI::Session::ActiveRecordStore::Session]
    return @models.sort{|a,b| a.to_s <=> b.to_s }
  end
  
##
#List all the controllers 
#  
 def controllers
    unless @controllers      
      for file in Dir.glob("#{RAILS_ROOT}/app/controllers/*.rb") do
        begin
          load file
        rescue
          logger.info "Couldn't load file '#{file}' (already loaded?)"
        end
      end
    end    
    @controllers = Hash.new    
    ObjectSpace.each_object(Class) do |klass|
      if klass.respond_to? :controller_name
          if klass.superclass.to_s == ApplicationController.to_s
            @controllers[klass.controller_name] = klass
          end
      end
    end
 end
    
##
# get the list of possible actions for this controller
# 
  def possible_actions(item)
    actions = Array.new
    controller = item
    if item.class = String
        controller = eval("#{controller}_controller".camelcase)
    end
    methods = controller.public_instance_methods - ApplicationController.public_instance_methods
    for method in methods.sort do
      action_collection << ControllerAction.new(:name => method)
    end
    return actions
  end

end
