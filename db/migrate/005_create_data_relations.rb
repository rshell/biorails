##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

# Create the Database Relations Table for holding complex many to many links between concepts
class CreateDataRelations < ActiveRecord::Migration
  def self.up
    create_table :data_relations, :force => true do |t|
      t.column "from_concept_id", :integer ,:limit => 32, :null => false #,:references => :data_contexts
      t.column "to_concept_id",   :integer ,:limit => 32, :null => false #,:references => :data_contexts
      t.column "role_concept_id", :integer ,:limit => 32, :null => false #,:references => :data_contexts
    end          

    add_index "data_relations", ["from_concept_id"], :name => "data_relations_from_idx"
    add_index "data_relations", ["to_concept_id"],   :name => "data_relations_to_idx"
    add_index "data_relations", ["role_concept_id"], :name => "data_relations_role_idx"

    add_foreign_key_constraint :data_relations, "from_concept_id", 
                               :data_concepts, "id",
                               :name => "data_relations_from_fk",
                               :on_delete => :cascade 
    
    add_foreign_key_constraint :data_relations, "to_concept_id", 
                               :data_concepts, "id",
                               :name => "data_relations_to_fk",
                               :on_delete => :cascade 
    
    add_foreign_key_constraint :data_relations, "role_concept_id", 
                               :data_concepts, "id",
                               :name => "data_relations_role_fk",
                               :on_delete => :cascade                                                        
  end

  def self.down
    drop_table :data_relations
  end
end
