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

class RolesPermission < ActiveRecord::Base

  def RolesPermission.find_for_role(role_ids)
    sql = <<SQL
select roles_permissions.*, permissions.name 
from roles_permissions inner join permissions 
  on roles_permissions.permission_id = permissions.id 
where role_id in (?) order by permissions.name
SQL

    return find_by_sql [sql, role_ids]
  end

end
