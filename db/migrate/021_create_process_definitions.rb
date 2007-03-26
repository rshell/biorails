##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

class CreateProcessDefinitions < ActiveRecord::Migration
  def self.up
  create_table :process_definitions, :force => true do |t|
    t.column "name", :string, :limit => 30, :null => false
    t.column "release", :string, :limit => 5, :null => false
    t.column "description", :text
    t.column "purpose", :text
    t.column "protocol_catagory", :string, :limit => 20, :null => true
    t.column "protocol_status", :string, :limit => 20, :null => true
    t.column "literature_ref", :string, :limit => 255
    t.column "access_control_id", :integer, :default => 0, :null => false
    t.column "lock_version", :integer,   :null => false, :default => 0
    t.column "created_by",   :string  ,:limit => 32, :null => false
    t.column "created_at",   :datetime,  :null => false
    t.column "updated_by",   :string  ,:limit => 32, :null => false
    t.column "updated_at",   :datetime,  :null => false
  end
  end

  def self.down
    drop_table :process_definitions
  end
end
