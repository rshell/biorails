##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class AddTaskTextsIndexes < ActiveRecord::Migration
  def self.up
    add_index "task_texts", ["task_id"]
    add_index "task_texts", ["task_context_id"]
    add_index "task_texts", ["parameter_id"]
    add_index "task_texts", ["updated_at"]
    add_index "task_texts", ["updated_by"]
  end

  def self.down
    remove_index "task_texts", ["task_id"]
    remove_index "task_texts", ["task_context_id"]
    remove_index "task_texts", ["parameter_id"]
    remove_index "task_texts", ["updated_at"]
    remove_index "task_texts", ["updated_by"]
  end
end
