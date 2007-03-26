##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class ModifyTaskContextAddParent < ActiveRecord::Migration
  def self.up
    add_column  :task_contexts, "row_no", :integer, :null => false
    add_column  :task_contexts, "parent_id", :integer, :null => true
  end

  def self.down
    remove_column  :task_contexts, "row_no"
    remove_column  :task_contexts, "parent_id"
  end
end
