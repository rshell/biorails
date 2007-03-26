##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class CreateContainerItems < ActiveRecord::Migration
  def self.up
    create_table :container_items do |t|
      t.column "container_group_id", :integer, :null=>false
      t.column "subject_type", :string, :null=>false
      t.column "subject_id", :integer, :null=>false
      t.column "slot_no", :integer, :null=>false
    end
  end

  def self.down
    drop_table :container_items
  end
end
