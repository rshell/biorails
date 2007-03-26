##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class CreateTreatmentItems < ActiveRecord::Migration
  def self.up
    create_table :treatment_items do |t|
      t.column "treatment_group_id", :integer, :null=>false
      t.column "subject_type", :string, :null=>false
      t.column "subject_id", :integer, :null=>false
      t.column "sequence_order", :integer, :null=>false
    end
  end

  def self.down
    drop_table :treatment_items
  end
end
