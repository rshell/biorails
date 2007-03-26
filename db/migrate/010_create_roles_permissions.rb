##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
class CreateRolesPermissions < ActiveRecord::Migration
  def self.up
    create_table :roles_permissions, :force => true do |t|
      t.column "role_id", :integer, :default => 0, :null => false
      t.column "permission_id", :integer, :default => 0, :null => false
    end
  
    add_index "roles_permissions", ["role_id"], :name => "fk_roles_permission_role_id"
    add_index "roles_permissions", ["permission_id"], :name => "fk_roles_permission_permission_id"
  end

  def self.down
    drop_table :roles_permissions
  end
end
