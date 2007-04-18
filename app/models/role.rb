# == Schema Information
# Schema version: 233
#
# Table name: roles
#
#  id              :integer(11)   not null, primary key
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
  cattr_accessor :cached_subjects
  cattr_accessor :cached_controllers
  serialize :cache

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :description

  has_many :permissions, :class_name=>'RolePermission',:include=>'permission'
  has_many :users
  has_many :memberships, :include=>[:user,:project]
 
##
# Test if the role permissions is cached?
# 
 def cached?
   !cache.nil?
 end
##
# Subjects
# 
 def subjects
   rebuild unless cached?
   cache.keys 
 end
##
#Actions for a given subject
# 
 def actions(subject)
   rebuild unless cached?
   cache[subject].keys   
 end  
##
# List of possible actions for over all controller
#  
 def possible_actions
   rebuild unless cached?
   all = []
   for subject in possible_subjects
     all << cache[subject].keys
     all = all.uniq
   end
   return all
 end
##
# Get a permission for a subject and actions
#   
 def allow?(subject,action)
   rebuild unless cached?
   if  (cache[subject.to_s] and  ( cache[subject.to_s][action.to_s] == true or cache[subject.to_s]['*'] == true))
       return true
   end
   return false
 end
 
 
 def permission?(user,subject,action)
   rebuild unless cached?
   return !( self.cache[subject.to_s].nil? or self.cache[subject.to_s][action.to_s].nil?)
 end
 
  
#Grant access 
# 
 def grant(subject,action)
    rebuild unless cached?
    return true unless Role.is_checked?(subject,action)
    unless allow?(subject,action)
       permission = self.permissions.create(:subject=>subject.to_s,:action=>action.to_s)
       self.cache ||= {}
       self.cache[subject.to_s] ||= {}
       self.cache[subject.to_s][action.to_s] = true
       logger.debug "granted #{subject} #{action}"
       return true
    end    
    return false
 end

##
# Deny access
#  
 def deny(subject,action)
    rebuild unless cached?
    item = RolePermission.find(:first,:conditions=>['role_id=? and subject=? and action=?',self.id, subject.to_s, action.to_s])
    if item
       item.destroy        
       self.cache[subject.to_s] ||= {}
       self.cache[subject.to_s][action.to_s]=false
       logger.debug "Denied #{subject} #{action}"
       return true
    end
    return false
 end

##
# Redo the  
 def reset_rights(rights)
   transaction do
     for subject in Role.possible_subjects.keys
       for action in Role.possible_actions(subject)
         if rights[subject] and rights[subject][action]
             grant(subject,action)
         elsif allow?(subject,action)
             deny(subject,action)
         end
       end
     end
    rebuild
  end
 end

##
# Grant all rights to a array of subjects
# 
 def grant_all(subjects = nil)
   subjects ||= Role.subjects.keys 
   for subject in subjects
     for action in Role.possible_actions(subject)
        grant(subject,action)
     end
   end
   self.save   
 end

##
# deny access to a list of subjects all methods will be denied
# 
 def deny_all(subjects = nil)
   subjects ||= Role.subjects.keys 
   for subject in subjects
     for action in Role.possible_actions(subject)
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
     self.cache= {}
     for subject in Role.possible_subjects.keys
        cache[subject] = {}
     end
     for item in permissions
        cache[item.subject] ||= {}
        cache[item.subject][item.action] = true
     end          
     self.save
 end

##
#
#
  def Role.is_checked?(subject,action)
      return ( Role.possible_subjects[subject] and Role.possible_subjects[subject].detect{|item|item.to_s == action.to_s})
  end
##
# List of possible actions
#   
  def Role.possible_actions(subject)
      Role.possible_subjects[subject] || []
  end
##
# Build the cache of all the menus and rights for roles
# 
  def Role.possible_subjects
     return @@cached_subjects if @@cached_subjects
     return Role.reload   
  end

##
# Force a reload of all the controllers,models,methods and cache infomation
# 
  def Role.reload   
     @@cached_subjects = {}
     @@cached_controllers = nil 
     for key in Role.controllers.keys
        controller = Role.controllers[key]
        if controller.respond_to?(:rights_subject)           
           @@cached_subjects[controller.rights_subject.to_s] ||=['*']
           @@cached_subjects[controller.rights_subject.to_s].concat(controller.rights_actions)
           @@cached_subjects[controller.rights_subject.to_s] = @@cached_subjects[controller.rights_subject.to_s].uniq
        else   
           @@cached_subjects[key] ||=['*']
        end
     end
     return @@cached_subjects
  end
   
##
#List all the controllers 
#  
 def Role.controllers
    unless @@cached_controllers and  @@cached_controllers.size>1  
      @@cached_controllers = {}
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


end
