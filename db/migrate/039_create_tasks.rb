##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.column "name", :string, :limit => 128, :default => "", :null => false
      t.column "description", :text      
      t.column "experiment_id", :integer
      t.column "process_instance_id", :integer
      t.column "status_id", :string
      t.column "is_milestone", :boolean
      t.column "assigned_to", :string, :limit => 60
      t.column "priority_id", :integer
      t.column "start_date", :datetime
      t.column "end_date", :datetime
      t.column "expected_hours", :double
      t.column "done_hours", :double
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "created_by", :string, :limit => 32, :default => "", :null => false
      t.column "created_at", :datetime, :null => false
      t.column "updated_by", :string, :limit => 32, :default => "", :null => false
      t.column "updated_at", :datetime, :null => false
    end
  end

  def self.down
    drop_table :tasks
  end
end
