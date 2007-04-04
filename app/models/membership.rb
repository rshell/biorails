# == Schema Information
# Schema version: 233
#
# Table name: memberships
#
#  id         :integer(11)   not null, primary key
#  user_id    :integer(11)   default(0), not null
#  project_id :integer(11)   default(0), not null
#  role_id    :integer(11)   default(0), not null
#  owner      :boolean(1)    
#  created_by :string(32)    default(sys), not null
#  created_at :datetime      not null
#  updated_by :string(32)    default(sys), not null
#  updated_at :datetime      not null
#

class Membership < ActiveRecord::Base
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
