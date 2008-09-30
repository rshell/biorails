# == Schema Information
# Schema version: 359
#
# Table name: role_permissions
#
#  id            :integer(4)      not null, primary key
#  role_id       :integer(4)      not null
#  permission_id :integer(4)
#  subject       :string(40)
#  action        :string(40)
#

# == Description
# A permission in a Role
# 
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class RolePermission < ActiveRecord::Base  
  belongs_to :role

  def to_s
    "#{subject}:#{action} "
  end
end
