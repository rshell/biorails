##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

class CreateProcessInstances < ActiveRecord::Migration
  def self.up
    create_table :process_instances, :force => true do |t|
      t.column "process_definition_id", :integer, :null => false
      t.column "name", :string, :limit => 77
      t.column "version", :integer, :limit => 6, :null => false
      t.column "lock_version", :integer,   :null => false, :default => 0
      t.column "created_by", :string, :limit => 32
      t.column "created_at", :time
      t.column "update_by", :string, :limit => 32
      t.column "update_at", :time
    end
  end

  def self.down
    drop_table :process_instances
  end
end
