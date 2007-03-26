##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
class CreateUsers < ActiveRecord::Migration
  def self.up

  create_table "users", :force => true do |t|
        t.column "name", :string, :default => "", :null => false
        t.column "password", :string, :limit => 40, :default => "", :null => false
        t.column "role_id", :integer, :default => 0, :null => false
        t.column "lock_version", :integer,   :null => false, :default => 0
        t.column "created_by",   :string  ,:limit => 32, :null => false, :default =>'sys'
        t.column "created_at",   :datetime,  :null => false, :default =>0
        t.column "updated_by",   :string  ,:limit => 32, :null => false,:default =>'sys'
        t.column "updated_at",   :datetime,  :null => false, :default =>0
  end

  add_index "users", ["role_id"], :name => "fk_user_role_id"
  execute "INSERT INTO `users` VALUES (2,'admin','d033e22ae348aeb5660fc2140aec35850c4da997',3,0,'sys',0,'sys',0)"

  end

  def self.down
    drop_table :users
  end
end
