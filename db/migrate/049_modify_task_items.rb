##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class ModifyTaskItems < ActiveRecord::Migration
  def self.up
    add_column  :task_values, "task_id", :integer, :null => true
    add_column  :task_texts, "task_id", :integer, :null => true
    add_column  :task_files, "task_id", :integer, :null => true
    add_column  :task_references, "task_id", :integer, :null => true
  end

  def self.down
    remove_column  :task_values, "task_id"
    remove_column  :task_text, "task_id"
    remove_column  :task_files, "task_id"
    remove_column  :task_references, "task_id"
  end
end
