##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
class CreateRoles < ActiveRecord::Migration
  def self.up
  create_table "roles", :force => true do |t|
    t.column "name", :string, :default => "", :null => false
    t.column "parent_id", :integer
    t.column "description", :string, :limit => 1024, :default => "", :null => false
    t.column "default_page_id", :integer
    t.column "cache", :text
    t.column "lock_version", :integer,   :null => false, :default => 0
    t.column "created_by",   :string  ,:limit => 32, :null => false, :default =>'sys'
    t.column "created_at",   :datetime,  :null => false, :default =>0
    t.column "updated_by",   :string  ,:limit => 32, :null => false,:default =>'sys'
    t.column "updated_at",   :datetime,  :null => false, :default =>0
  end

  add_index "roles", ["parent_id"], :name => "fk_role_parent_id"
  add_index "roles", ["default_page_id"], :name => "fk_role_default_page_id"

  execute "INSERT INTO `roles` VALUES (1,'Public',NULL,'Members of the public who are not logged in.',NULL,NULL,0,'sys','2006-06-23 11:03:49','sys','2006-10-02 04:13:10')"
  execute "INSERT INTO `roles` VALUES (2,'Member',1,'',NULL,NULL,0,'sys','2006-06-23 11:03:49','sys','2006-10-02 04:13:10')"
  execute "INSERT INTO `roles` VALUES (3,'Administrator',2,'',8,NULL,0,'sys','2006-06-23 11:03:49','sys','2006-10-02 04:13:10')"
  
  end

  def self.down
    drop_table :roles
  end
end
