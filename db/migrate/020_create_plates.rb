##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

class CreatePlates < ActiveRecord::Migration
  def self.up
    create_table :plates, :force => true  do |t|
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
  end

  def self.down
    drop_table :plates
  end
end
