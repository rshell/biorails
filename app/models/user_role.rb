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
# syb type of Role defines the user level rights of a user
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#

class UserRole < Role

  def self.subjects
    USER_SUBJECTS
  end

end
