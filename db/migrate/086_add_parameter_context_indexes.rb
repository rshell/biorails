##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class AddParameterContextIndexes < ActiveRecord::Migration
  def self.up
    add_index "parameter_contexts", ["process_instance_id"]
    add_index "parameter_contexts", ["parent_id"]
    add_index "parameter_contexts", ["label"]
  end

  def self.down
    remove_index "parameter_contexts", ["process_instance_id"]
    remove_index "parameter_contexts", ["parent_id"]
    remove_index "parameter_contexts", ["label"]
  end
end
