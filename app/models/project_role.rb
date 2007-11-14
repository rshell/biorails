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


class ProjectRole < Role
#
#  Define rules to link to actual database records for ROLES
# 
   DEFAULT_OWNER_ROLE = 5
   DEFAULT_PROJECT_ROLE = 2

  def self.subjects
    Permission.subjects(:current_project)
  end
#
# Get the default role as a the owner of project
#
  def self.owner
    self.find(DEFAULT_OWNER_ROLE)
  end
#
# Get the default role as a member of the project
#
  def self.member
    self.find(DEFAULT_MEMBER_ROLE)    
  end

end
