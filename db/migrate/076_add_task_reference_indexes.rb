##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class AddTaskReferenceIndexes < ActiveRecord::Migration
  def self.up
    add_index "task_references", ["task_id"]
    add_index "task_references", ["task_context_id"]
    add_index "task_references", ["parameter_id"]
    add_index "task_references", ["updated_at"]
    add_index "task_references", ["updated_by"]
  end

  def self.down
    remove_index "task_references", ["task_id"]
    remove_index "task_references", ["task_context_id"]
    remove_index "task_references", ["parameter_id"]
    remove_index "task_references", ["updated_at"]
    remove_index "task_references", ["updated_by"]
  end
end
