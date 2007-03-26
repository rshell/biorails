##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

# Create the Database Data_Environment Table to hold physical systems linked into
# biorails  
#
class CreateDataConcepts < ActiveRecord::Migration
  def self.up
    create_table :data_concepts , :force => true do |t|
        t.column "parent_id", :integer
        t.column "name", :string, :limit => 50, :default => "", :null => false
        t.column "data_context_id", :integer, :default =>1, :null=> false #, :references => :data_contexts
        t.column "description", :text
        t.column "access_control_id", :integer
        t.column "lock_version", :integer,   :null => false, :default => 0
        t.column "created_by",   :string  ,:limit => 32, :null => false, :default =>'sys'
        t.column "created_at",   :datetime,  :null => false, :default =>0
        t.column "updated_by",   :string  ,:limit => 32, :null => false,:default =>'sys'
        t.column "updated_at",   :datetime,  :null => false, :default =>0
    end

    add_index :data_concepts, ["updated_by"], :name => "data_concepts_idx1"
    add_index :data_concepts, ["updated_at"], :name => "data_concepts_idx2"
    add_index :data_concepts, ["created_by"], :name => "data_concepts_idx3"
    add_index :data_concepts, ["created_at"], :name => "data_concepts_idx4"
    add_index :data_concepts, ["name"], :name => "data_concepts_name_idx"
    add_index :data_concepts, ["access_control_id"], :name => "data_concepts_acl_idx"
    
    add_foreign_key_constraint :data_concepts, "data_context_id", 
                               :data_contexts, "id",
                               :name => "data_concepts_fk1",
                               :on_delete => :cascade
                                

  end

  def self.down
    drop_table :data_concepts
  end
end
