# == Schema Information
# Schema version: 233
#
# Table name: role_permissions
#
#  id            :integer(11)   not null, primary key
#  role_id       :integer(11)   not null
#  subject       :string(40)    
#  action        :string(40)    
#  permission_id :integer(11)   
#

##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class RolePermission < ActiveRecord::Base
  
  belongs_to :role
  belongs_to :permission
  
  
 
end
