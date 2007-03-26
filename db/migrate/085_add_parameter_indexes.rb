##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class AddParameterIndexes < ActiveRecord::Migration
  def self.up
    add_index "parameters", ["name"]
    add_index "parameters", ["process_instance_id"]
    add_index "parameters", ["parameter_context_id"]
    add_index "parameters", ["parameter_type_id"]
    add_index "parameters", ["parameter_role_id"]
    add_index "parameters", ["updated_by"]
    add_index "parameters", ["updated_at"]
  end

  def self.down
    remove_index "parameters", ["name"]
    remove_index "parameters", ["process_instance_id"]
    remove_index "parameters", ["parameter_context_id"]
    remove_index "parameters", ["parameter_type_id"]
    remove_index "parameters", ["parameter_role_id"]
    remove_index "parameters", ["updated_by"]
    remove_index "parameters", ["updated_at"]
  end
end
