##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class AddTaskIndexes < ActiveRecord::Migration
  def self.up  
    add_index "tasks",["name"]
    add_index "tasks",["experiment_id"]
    add_index "tasks",["process_instance_id"]
    add_index "tasks",["study_protocol_id"]
    add_index "tasks",["start_date"]
    add_index "tasks",["end_date"]
  end

  def self.down
    remove_index "tasks",["name"]
    remove_index "tasks",["experiment_id"]
    remove_index "tasks",["process_instance_id"]
    remove_index "tasks",["study_protocol_id"]
    remove_index "tasks",["start_date"]
    remove_index "tasks",["end_date"]
  end
end
