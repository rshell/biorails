# == Schema Information
# Schema version: 306
#
# Table name: roles
#
#  id                 :integer(11)   not null, primary key
#  name               :string(255)   default(), not null
#  parent_id          :integer(11)   
#  description        :string(1024)  default(), not null
#  cache              :string(4000)  default()
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
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

  has_many :permissions, :class_name=>'RolePermission'
  has_many :users
  has_many :memberships, :include=>[:user,:team]

  def initialize(params= {})
      super(params) 
      self.cache = {}      
  end

###
# Test if the role permissions is cached?
# 
 def cached?
   self.cache.size > 0
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
# Get a permission for a subject and actions
#   
 def allow?(subject,action)
   self.rebuild unless self.cached?
   return false if self.cache[subject.to_s].nil?
   if ( self.cache[subject.to_s][action.to_s] == true or cache[subject.to_s]['*'] == true)
       return true
   end
   return false
 end
 
 
 def permission?(user,subject,action)
   if  allow?(subject,action)
     logger.debug("passed permission? #{user.to_s} #{subject} #{action}")
     return  true
   else
     logger.debug("failed permission? #{user.to_s} #{subject} #{action}")
     return false
   end
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
       logger.info "action #{subject}:#{action}"
         if rights[subject] and ( rights[subject][action] || rights[subject]['*'])
             self.grant(subject,action)
         elsif self.allow?(subject,action)
             self.deny(subject,action)
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
     for action in Permission.possible_actions(subject)
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
        self.cache[subject.to_s] = {}
     end
     for item in self.permissions
        self.cache[item.subject.to_s] ||= {}
        self.cache[item.subject.to_s][item.action.to_s] = true
        logger.info "add #{item.subject}:#{item.action}"
     end          
     self.save
 end

end
