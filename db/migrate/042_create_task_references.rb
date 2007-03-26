##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class CreateTaskReferences < ActiveRecord::Migration
  def self.up
    create_table :task_references do |t|
      t.column "task_context_id", :integer
      t.column "parameter_id",:integer
      t.column "data_element_id",:integer
      t.column "data_type", :string
      t.column "data_id", :integer
      t.column "data_name", :string
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "created_by", :string, :limit => 32, :default => "", :null => false
      t.column "created_at", :datetime, :null => false
      t.column "updated_by", :string, :limit => 32, :default => "", :null => false
      t.column "updated_at", :datetime, :null => false
    end
  end

  def self.down
    drop_table :task_references
  end
end
