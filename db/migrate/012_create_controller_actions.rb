##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
class CreateControllerActions < ActiveRecord::Migration
  def self.up
    create_table :controller_actions, :force => true do |t|
      t.column "site_controller_id", :integer, :default => 0, :null => false
      t.column "name", :string, :default => "", :null => false
      t.column "permission_id", :integer
    end
  
    add_index "controller_actions", ["permission_id"], :name => "fk_controller_action_permission_id"
    add_index "controller_actions", ["site_controller_id"], :name => "fk_controller_action_site_controller_id"
    
    execute "INSERT INTO `controller_actions` VALUES (1,1,'view_default',3)"
    execute "INSERT INTO `controller_actions` VALUES (2,1,'view',3)"
    execute "INSERT INTO `controller_actions` VALUES (3,7,'list',NULL)"
    execute "INSERT INTO `controller_actions` VALUES (4,6,'list',NULL)"
    execute "INSERT INTO `controller_actions` VALUES (5,3,'login',4)"
    execute "INSERT INTO `controller_actions` VALUES (6,3,'logout',4)"
    execute "INSERT INTO `controller_actions` VALUES (7,5,'link',4)"
    execute "INSERT INTO `controller_actions` VALUES (8,1,'list',NULL)"
    execute "INSERT INTO `controller_actions` VALUES (9,8,'list',NULL)"
    execute "INSERT INTO `controller_actions` VALUES (10,2,'list',NULL)"
    execute "INSERT INTO `controller_actions` VALUES (11,5,'list',NULL)"
    execute "INSERT INTO `controller_actions` VALUES (12,9,'list',NULL)"
    execute "INSERT INTO `controller_actions` VALUES (13,3,'forgotten',4)"
    execute "INSERT INTO `controller_actions` VALUES (14,3,'login_failed',4)"
    execute "INSERT INTO `controller_actions` VALUES (15,10,'list',NULL)"

   end

  def self.down
    drop_table :controller_actions
    execute "drop table if exists mscontroller_actions cascade"
   rescue
     nil
  end
end
