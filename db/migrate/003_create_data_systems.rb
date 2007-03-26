##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

# Create the Database Data_Systems Table to hold physical systems linked into
# biorails  
#
class CreateDataSystems < ActiveRecord::Migration
  def self.up
    create_table :data_systems, :force => true do |t|
        t.column "name", :string, :limit => 50, :default => "", :null => false
        t.column "description", :text
        t.column "data_context_id", :integer, :default =>1, :null=> false 
        t.column "access_control_id", :integer
        t.column "lock_version", :integer,   :null => false, :default => 0
        t.column "created_by",   :string  ,:limit => 32, :null => false, :default =>'sys'
        t.column "created_at",   :datetime,  :null => false, :default =>0
        t.column "updated_by",   :string  ,:limit => 32, :null => false,:default =>'sys'
        t.column "updated_at",   :datetime,  :null => false, :default =>0
    end

    add_index :data_systems, ["updated_by"], :name => "data_systems_idx1"
    add_index :data_systems, ["updated_at"], :name => "data_systems_idx2"
    add_index :data_systems, ["created_by"], :name => "data_systems_idx3"
    add_index :data_systems, ["created_at"], :name => "data_systems_idx4"
    add_index :data_systems, ["name"], :name => "data_systems_name_idx"
    add_index :data_systems, ["access_control_id"], :name => "data_systems_acl_idx"
    
    add_foreign_key_constraint :data_systems, "data_context_id", 
                               :data_contexts, "id",
                               :name => "data_environments_fk1",
                               :on_delete => :cascade
  end

  def self.down
    drop_table :data_systems
  end
end
