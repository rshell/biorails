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
  
 belongs_to :user
 belongs_to :project
 belongs_to :role 
##
# Test if this role allows this action to this subject eg.
# 
#  allows?('study','new')
 def allows?(subject,action)  
   return (self.owner or self.role.allow?(subject,action))
 end
 
end
