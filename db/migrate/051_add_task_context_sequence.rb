##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
##
# Add Sequence number for automatic label generation
# 
class AddTaskContextSequence < ActiveRecord::Migration
  def self.up
    add_column  :task_contexts, "sequence_no", :integer, :null => false
  end

  def self.down
    remove_column  :task_contexts, "sequence_no"
  end
end
