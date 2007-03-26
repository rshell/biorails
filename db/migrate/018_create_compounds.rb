##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

##
# Example Compound Name for demo of inventory
# 
class CreateCompounds < ActiveRecord::Migration
  def self.up
    create_table :compounds, :force => true  do |t|
        t.column "parent_id", :integer,  :default => 0, :null => false
        t.column "name", :string
        t.column "description", :text
        t.column "external_ref", :string
        t.column "formula", :string
        t.column "mass", :float
        t.column "cas_number", :string    
        t.column "smiles", :string
        t.column "chemistry",:text
        t.column "url", :string
        t.column "lock_version", :integer,   :null => false, :default => 0
        t.column "created_by",   :string  ,:limit => 32, :null => false, :default =>'sys'
        t.column "created_at",   :datetime,  :null => false, :default =>0
        t.column "updated_by",   :string  ,:limit => 32, :null => false,:default =>'sys'
        t.column "updated_at",   :datetime,  :null => false, :default =>0
    end
  end

  def self.down
    drop_table :compounds
  end
end
