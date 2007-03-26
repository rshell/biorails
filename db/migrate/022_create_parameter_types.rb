##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

class CreateParameterTypes < ActiveRecord::Migration
  def self.up
    create_table :parameter_types do |t|
      t.column "name", :string, :limit => 50, :null => false
      t.column "description",  :string,  :limit => 255, :null => false
      t.column "weighing",     :integer, :null => false, :default => 0
      t.column "lock_version", :integer, :null => false, :default => 0
      t.column "created_by",   :string  ,:limit => 32, :null => false
      t.column "created_at",   :datetime,:null => false
      t.column "updated_by",   :string  ,:limit => 32, :null => false
      t.column "updated_at",   :datetime,:null => false
    end
  end

  def self.down
    drop_table :parameter_types
  end
end
