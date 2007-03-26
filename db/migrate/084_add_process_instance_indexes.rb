##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class AddProcessInstanceIndexes < ActiveRecord::Migration
  def self.up
    add_index "process_instances", ["name"]
    add_index "process_instances", ["process_definition_id"]
    add_index "process_instances", ["updated_by"]
    add_index "process_instances", ["updated_at"]
  end

  def self.down
    remove_index "process_instances", ["name"]
    remove_index "process_instances", ["process_definition_id"]
    remove_index "process_instances", ["updated_by"]
    remove_index "process_instances", ["updated_at"]
  end
end
