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
# This represents the role of a project
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#

class ProjectRole < Role
  
      
  def self.subjects
    PROJECT_SUBJECTS
  end
#
# Get the default role as a the owner of project
#
  def self.owner
    self.find(Biorails::Record::DEFAULT_OWNER_ROLE)
  end
#
# Get the default role as a member of the project
#
  def self.member
    self.find(Biorails::Record::DEFAULT_PROJECT_ROLE)    
  end

end
