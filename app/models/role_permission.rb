# == Schema Information
# Schema version: 123
#
# Table name: roles_permissions
#
#  id            :integer(11)   not null, primary key
#  role_id       :integer(11)   not null
#  permission_id :integer(11)   not null
#

##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class RolePermission < ActiveRecord::Base

  belongs_to :role
  belongs_to :permission
  
  
 
end
