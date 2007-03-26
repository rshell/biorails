##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class AddProcessDefinitionIndexes < ActiveRecord::Migration
  def self.up
    add_index "process_definitions", ["name"]
    add_index "process_definitions", ["updated_by"]
    add_index "process_definitions", ["updated_at"]
  end

  def self.down
    remove_index "process_definitions", ["name"]
    remove_index "process_definitions", ["updated_by"]
    remove_index "process_definitions", ["updated_at"]
  end
end
