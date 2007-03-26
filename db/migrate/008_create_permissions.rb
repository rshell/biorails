##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

class CreatePermissions < ActiveRecord::Migration
  def self.up
  create_table "permissions", :force => true do |t|
    t.column "name", :string, :default => "", :null => false
  end
  execute "INSERT INTO `permissions` VALUES (1,'Administer site')"
  execute "INSERT INTO `permissions` VALUES (2,'Public pages - edit')"
  execute "INSERT INTO `permissions` VALUES (3,'Public pages - view')"
  execute "INSERT INTO `permissions` VALUES (4,'Public actions - execute')"
  execute "INSERT INTO `permissions` VALUES (5,'Members only page -- view')"
  
  end

  def self.down
    drop_table :permissions
  end
end
