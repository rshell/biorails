##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
class CreateSiteControllers < ActiveRecord::Migration
  def self.up
    create_table :site_controllers, :force => true do |t|
      t.column "name", :string, :default => "", :null => false
      t.column "permission_id", :integer, :default => 0, :null => false
      t.column "builtin", :integer, :limit => 10, :default => 0
    end
  
    add_index "site_controllers", ["permission_id"], :name => "fk_site_controller_permission_id"

    execute "INSERT INTO `site_controllers` VALUES (1,'content_pages',1,1)"
    execute "INSERT INTO `site_controllers` VALUES (2,'controller_actions',1,1)"
    execute "INSERT INTO `site_controllers` VALUES (3,'auth',1,1)"
    execute "INSERT INTO `site_controllers` VALUES (4,'markup_styles',1,1)"
    execute "INSERT INTO `site_controllers` VALUES (5,'menu_items',1,1)"
    execute "INSERT INTO `site_controllers` VALUES (6,'permissions',1,1)"
    execute "INSERT INTO `site_controllers` VALUES (7,'roles',1,1)"
    execute "INSERT INTO `site_controllers` VALUES (8,'site_controllers',1,1)"
    execute "INSERT INTO `site_controllers` VALUES (9,'system_settings',1,1)"
    execute "INSERT INTO `site_controllers` VALUES (10,'users',1,1)"
    execute "INSERT INTO `site_controllers` VALUES (11,'roles_permissions',1,1)"

  end

  def self.down
    drop_table :site_controllers
  end
end
