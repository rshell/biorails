##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

# Create the Database Data_Elements Table to hold physical lists of values for use 
#
class CreateDataElements < ActiveRecord::Migration
  def self.up
    create_table :data_elements, :force => true do |t|
        t.column "name", :string, :limit => 50, :default => "", :null => false
        t.column "description", :text
        t.column "style", :string, :limit => 10, :default => "Child", :null => false
        t.column "content", :text
        t.column "parent_id", :integer, :null=> true 
        t.column "data_system_id", :integer, :default =>1, :null=> false 
        t.column "data_concept_id", :integer, :default =>1, :null=> false 
        t.column "access_control_id", :integer
        t.column "lock_version", :integer,   :null => false, :default => 0
        t.column "created_by",   :string  ,:limit => 32, :null => false, :default =>'sys'
        t.column "created_at",   :datetime,  :null => false, :default =>0
        t.column "updated_by",   :string  ,:limit => 32, :null => false,:default =>'sys'
        t.column "updated_at",   :datetime,  :null => false, :default =>0
    end

    add_index :data_elements, ["updated_by"], :name => "data_elements_idx1"
    add_index :data_elements, ["updated_at"], :name => "data_elements_idx2"
    add_index :data_elements, ["created_by"], :name => "data_elements_idx3"
    add_index :data_elements, ["created_at"], :name => "data_elements_idx4"
    add_index :data_elements, ["parent_id"],  :name => "data_elements_idx5"
    add_index :data_elements, ["name"], :name => "data_elements_name_idx"
    add_index :data_elements, ["access_control_id"], :name => "data_elements_acl_idx"
    
    add_foreign_key_constraint :data_elements, "data_system_id", 
                               :data_systems, "id",
                               :name => "data_element_fk1",
                               :on_delete => :cascade 

    add_foreign_key_constraint :data_elements, "data_concept_id", 
                               :data_concepts, "id",
                               :name => "data_element_fk2",
                               :on_delete => :cascade
                                
    add_foreign_key_constraint :data_elements, "parent_id", 
                               :data_elements, "id",
                               :name => "data_element_fk3",
                               :on_delete => :cascade
                                
  end

  def self.down
    drop_table :data_elements
  end
end
