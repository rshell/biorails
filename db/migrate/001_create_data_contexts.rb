##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

class CreateDataContexts < ActiveRecord::Migration
  def self.up
    create_table :data_contexts  do |t|
        t.column "name", :string, :limit => 50, :default => "", :null => false
        t.column "description", :text
        t.column "access_control_id", :integer
        t.column "lock_version", :integer,   :null => false, :default => 0
        t.column "created_by",   :string  ,:limit => 32, :null => false, :default =>'sys'
        t.column "created_at",   :datetime,  :null => false, :default =>0
        t.column "updated_by",   :string  ,:limit => 32, :null => false,:default =>'sys'
        t.column "updated_at",   :datetime,  :null => false, :default =>0
    end
  
    add_index "data_contexts", ["updated_by"], :name => "data_contexts_idx1"
    add_index "data_contexts", ["updated_at"], :name => "data_contexts_idx2"
    add_index "data_contexts", ["created_by"], :name => "data_contexts_idx3"
    add_index "data_contexts", ["created_at"], :name => "data_contexts_idx4"
    add_index "data_contexts", ["name"], :name => "data_contexts_name_idx"
    add_index "data_contexts", ["access_control_id"], :name => "data_contexts_acl_idx"
  end

  def self.down
    drop_table :data_contexts
  end
end
