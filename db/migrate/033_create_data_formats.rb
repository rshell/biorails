##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

#
# looking for a lookup of data format rules
#
class CreateDataFormats < ActiveRecord::Migration
  def self.up
    create_table :data_formats do |t|
      t.column :name, :string
      t.column "name", :string, :limit => 128, :default => "", :null => false
      t.column "description", :text
      t.column "data_type", :string
      t.column "default_value", :string, :null => true
      t.column "format_regex", :string, :null => true
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "created_by", :string, :limit => 32, :default => "", :null => false
      t.column "created_at", :datetime, :null => false
      t.column "updated_by", :string, :limit => 32, :default => "", :null => false
      t.column "updated_at", :datetime, :null => false
    end
  end

  def self.down
    drop_table :data_formats
  end
end
