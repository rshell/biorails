# == Schema Information
# Schema version: 359
#
# Table name: roles
#
#  id                 :integer(4)      not null, primary key
#  type               :string(255)
#  name               :string(255)     default(""), not null
#  parent_id          :integer(4)
#  description        :string(1024)    default(""), not null
#  cache              :string(4000)    default("")
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  created_by_user_id :integer(4)      default(1), not null
#  updated_by_user_id :integer(4)      default(1), not null
#

# == Description
# A Role represents a list of access controls rights
# 
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class Role < ActiveRecord::Base
  serialize :cache
  
  USER_SUBJECTS = {
        'reports'=> ['build','use'],
        'project'=> ['build','use'],
        'execution'=> ['all'],
        'organization'=> ['build','use'],
        'catalogue'=>['admin'],
        'system'=>['admin']
  }
  PROJECT_SUBJECTS = {
        'data'=> ['create','update','destroy','share','assign','verify'],
        'document'=> ['sign','witness','publish','withdraw']
  }
  
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
  #
  # overide with list for role subtype
  #
  def self.subjects
    USER_SUBJECTS.merge(PROJECT_SUBJECTS)
  end
  
  def self.possible_actions(subject)
    subjects[subject.to_s] || []
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
    return [] unless cache[subject]
    cache[subject].keys   
  end  
  
  ##
  # Get a permission for a subject and actions
  #   
  def allow?(subject,action)
    self.rebuild unless self.cached?
    return false unless self.cache[subject.to_s]
    if ( self.cache[subject.to_s][action.to_s] == true or cache[subject.to_s]['*'] == true)
      return true
    end
    return false
  end 
  #
  # See if the user as a specific role in the acl (teams ignored)
  #
  def rights?(subject)
    self.rebuild unless self.cached?
    return self.cache[subject.to_s]
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
      self.cache[subject.to_s][action.to_s]=nil
      logger.debug "Denied #{subject} #{action}"
      return true
    end
    logger.debug "didnt have  #{subject} #{action}"
    return false
  end
  
  ##
  # Redo the  
  def reset_rights(rights)
    return unless rights and rights.size>0
    transaction do
      self.cache ={}
      for subject in self.class.subjects.keys
        for action in self.class.possible_actions(subject)
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
    subjects ||= self.class.subjects.keys 
    for subject in subjects
      for action in self.class.possible_actions(subject)
        grant(subject,action)
      end
    end
    self.save   
  end
  
  ##
  # deny access to a list of subjects all methods will be denied
  # 
  def deny_all(subjects = nil)
    subjects ||= self.class.subjects.keys 
    for subject in subjects
      for action in self.class.possible_actions(subject)
        deny(subject,action)
      end
    end
    self.save   
  end
  
  
  def to_s
    permissions.inject("role[#{name}] ") do |sum, item|
      sum << item.to_s 
    end
  end
  
  ##
  # Rebuild the cache
  #   
  def rebuild
    logger.info "rebuild rights cache"
    self.cache= {}
    for item in self.permissions
      self.cache[item.subject.to_s] ||= {}
      self.cache[item.subject.to_s][item.action.to_s] = true
      logger.info "add #{item.subject}:#{item.action}"
    end          
    self.save
  end
  
end
