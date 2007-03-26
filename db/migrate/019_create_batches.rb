##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

class CreateBatches < ActiveRecord::Migration
  def self.up
    create_table :batches, :force => true  do |t|
        t.column "compound_id", :integer,  :default => 0, :null => false
        t.column "name", :string
        t.column "description", :text
        t.column "external_ref", :string
        t.column "quantity_unit", :string
        t.column "quantity_value", :float
        t.column "url", :string
        t.column "lock_version", :integer,   :null => false, :default => 0
        t.column "created_by",   :string  ,:limit => 32, :null => false, :default =>'sys'
        t.column "created_at",   :datetime,  :null => false, :default =>0
        t.column "updated_by",   :string  ,:limit => 32, :null => false,:default =>'sys'
        t.column "updated_at",   :datetime,  :null => false, :default =>0
    end

    add_foreign_key_constraint :batches, "compound_id", 
                               :compounds, "id",
                               :name => "batches_compound_fk",
                               :on_delete => :cascade 
    
  end

  def self.down
    drop_table :batches
  end
end
