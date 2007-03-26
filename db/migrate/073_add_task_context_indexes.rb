##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class AddTaskContextIndexes < ActiveRecord::Migration
  def self.up
    add_index "task_contexts", ["task_id"]
    add_index "task_contexts", ["parameter_context_id"]
    add_index "task_contexts", ["row_no"]
    add_index "task_contexts", ["label"]
  end

  def self.down
    remove_index "task_contexts", ["task_id"]
    remove_index "task_contexts", ["parameter_context_id"]
    remove_index "task_contexts", ["row_no"]
    remove_index "task_contexts", ["label"]
  end
end
