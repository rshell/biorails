##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class CreateDataTypes < ActiveRecord::Migration
  def self.up
    create_table :data_types do |t|
      t.column "name", :string
      t.column "description", :string
      t.column "value_class", :string
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "created_by", :string, :limit => 32, :default => "", :null => false
      t.column "created_at", :datetime, :null => false
      t.column "updated_by", :string, :limit => 32, :default => "", :null => false
      t.column "updated_at", :datetime, :null => false    end
  end

  def self.down
    drop_table :data_types
  end
end
