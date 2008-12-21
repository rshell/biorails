# == Schema Information
# Schema version: 359
#
# Table name: memberships
#
#  id                 :integer(4)      not null, primary key
#  user_id            :integer(4)      default(0), not null
#  role_id            :integer(4)      default(0), not null
#  is_owner           :boolean(1)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#  team_id            :integer(4)      default(0), not null
#

# == Description
# This represents a User's membership of a Team and assigns a Actice Role to govern acess control.
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class Membership < ActiveRecord::Base
  attr_accessor :role_id  # historic field now removed, kept here so old fixtures can be reloaded as needed
##
# This record has a full audit log created for changes 
#   
 acts_as_audited :change_log

  validates_uniqueness_of :user_id,:scope=>'team_id'
  validates_presence_of :user
  validates_presence_of :team
  validates_associated :user
  validates_associated :team
  
  belongs_to :user, :class_name=>'User', :foreign_key =>'user_id'
  belongs_to :team, :class_name=>'Team', :foreign_key =>'team_id'

  after_save :sync_owners
  
 def sync_owners
    if owner? and team and team.access_control_list
       team.access_control_list.grant(user,ProjectRole.owner) 
    end      
 end
 
 def owner?
   self.is_owner
 end
 
 def owner=(value)
   self.is_owner = value 
 end

 def owner
   self.is_owner.to_s  == self.connection.quoted_true
 end

 def to_s
   user.name if user
 end
 
end
