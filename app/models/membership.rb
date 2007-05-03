# == Schema Information
# Schema version: 239
#
# Table name: memberships
#
#  id                 :integer(11)   not null, primary key
#  user_id            :integer(11)   default(0), not null
#  project_id         :integer(11)   default(0), not null
#  role_id            :integer(11)   default(0), not null
#  owner              :boolean(1)    
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#

class Membership < ActiveRecord::Base
##
# This record has a full audit log created for changes 
#   
 acts_as_audited :change_log

  validates_uniqueness_of :user_id,:scope=>'project_id'
  validates_presence_of :user
  validates_presence_of :project
  validates_presence_of :role
  
 belongs_to :user, :class_name=>'User', :foreign_key =>'user_id'
 belongs_to :project, :class_name=>'Project', :foreign_key =>'project_id'
 belongs_to :role, :class_name=>'Role', :foreign_key =>'role_id' 
##
# Test if this role allows this action to this subject eg.
# 
#  allows?('study','new')
 def allows?(subject,action)  
   return (self.owner or self.role.allow?(subject,action))
 end
 
end
