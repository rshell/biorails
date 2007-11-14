# == Schema Information
# Schema version: 280
#
# Table name: roles
#
#  id                 :integer(11)   not null, primary key
#  name               :string(255)   default(), not null
#  parent_id          :integer(11)   
#  description        :string(1024)  default(), not null
#  cache              :text          
#  created_at         :timestamp     not null
#  updated_at         :timestamp     not null
#  created_by_user_id :integer(11)   default(1), not null
#  updated_by_user_id :integer(11)   default(1), not null
#  type               :string(255)   
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class Role < ActiveRecord::Base
  serialize :cache

##
# This record has a full audit log created for changes 
#   
#  acts_as_audited :change_log

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :description

  has_many :permissions, :class_name=>'RolePermission',:include=>'permission'
  has_many :users
  has_many :memberships, :include=>[:user,:project]

  
###
# Test if the role permissions is cached?
# 
 def cached?
   !cache.nil?
 end

  def self.subjects
    Permission.possible_subjects
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
   return false if self.cache[subject.to_s].nil?
   if ( cache[subject.to_s][action.to_s] == true or cache[subject.to_s]['*'] == true)
       return true
   end
   return false
 end
 
 
 def permission?(user,subject,action)
   logger.info("check permission? #{user} #{subject} #{action}")
   return  allow?(subject,action)
 end
 
  
#Grant access 
# 
 def grant(subject,action)
    return true unless Permission.is_checked?(subject,action)
    permission = RolePermission.find(:first,:conditions=>['role_id=? and subject=? and action=?',self.id, subject.to_s, action.to_s])
    unless permission
       permission = self.permissions.create(:subject=>subject.to_s,:action=>action.to_s)
       self.cache ||= {}
       self.cache[subject.to_s] ||= {}
       self.cache[subject.to_s][action.to_s] = true       
       logger.debug "granted #{subject} #{action}"
       return true
    end    
   logger.debug "had  #{subject} #{action}"
    return false
 end

##
# Deny access
#  
 def deny(subject,action)
    item = RolePermission.find(:first,:conditions=>['role_id=? and subject=? and action=?',self.id, subject.to_s, action.to_s])
    if item
       item.destroy        
       self.cache[subject.to_s] ||= {}
       self.cache[subject.to_s][action.to_s]=false
       logger.debug "Denied #{subject} #{action}"
       return true
    end
   logger.debug "didnt have  #{subject} #{action}"
    return false
 end

##
# Redo the  
 def reset_rights(rights)
   transaction do
     for subject in Permission.possible_subjects.keys
      logger.debug "subject #{subject}==========================================================="
      logger.debug rights[subject].to_s
       for action in Permission.possible_actions(subject)
      logger.debug "action #{subject}:#{action}"
         if rights[subject] and ( rights[subject][action] || rights[subject]['*'])
             grant(subject,action)
         elsif allow?(subject,action)
             deny(subject,action)
         end
       end
     end
     self.save
    rebuild
  end
 end

##
# Grant all rights to a array of subjects
# 
 def grant_all(subjects = nil)
   subjects ||= Permission.possible_subjects.keys 
   for subject in subjects
     for action in Permission.possible_actions(subject)
        grant(subject,action)
     end
   end
   self.save   
 end

##
# deny access to a list of subjects all methods will be denied
# 
 def deny_all(subjects = nil)
   subjects ||= Permission.possible_subjects.keys 
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
     for subject in Permission.possible_subjects.keys
        cache[subject] = {}
     end
     for item in permissions
        cache[item.subject] ||= {}
        cache[item.subject][item.action] = true
     end          
     self.save
 end

end
