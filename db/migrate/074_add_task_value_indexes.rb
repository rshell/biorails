##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class AddTaskValueIndexes < ActiveRecord::Migration
  def self.up
    add_index "task_values", ["task_id"]
    add_index "task_values", ["task_context_id"]
    add_index "task_values", ["parameter_id"]
    add_index "task_values", ["updated_at"]
    add_index "task_values", ["updated_by"]
   end

  def self.down
    remove_index "task_values", ["task_id"]
    remove_index "task_values", ["task_context_id"]
    remove_index "task_values", ["parameter_id"]
    remove_index "task_values", ["updated_at"]
    remove_index "task_values", ["updated_by"]
  end
end
