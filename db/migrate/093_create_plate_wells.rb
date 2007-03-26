##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class CreatePlateWells < ActiveRecord::Migration
  def self.up
    create_table :plate_wells do |t|
      t.column "name", :string, :limit => 128, :default => "", :null => false
      t.column "label", :string      
      t.column "row_no", :integer, :default =>0, :null=>false
      t.column "column_no", :integer, :default =>0, :null=>false
      t.column "slot_no",:integer, :default =>0, :null=>false
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "created_by", :string, :limit => 32, :default => "", :null => false
      t.column "created_at", :datetime, :null => false
      t.column "updated_by", :string, :limit => 32, :default => "", :null => false
      t.column "updated_at", :datetime, :null => false    
    end
  end

  def self.down
    drop_table :plate_wells
  end
end
