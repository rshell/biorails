##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class ModifyParameterDefaults < ActiveRecord::Migration
  def self.up
    change_column  :parameters, "data_element_id", :integer, :null => true
    add_column  :parameters, "data_type_id", :integer, :null => true
    remove_column  :parameters, "data_type"
  end

  def self.down
    add_column  :parameters, "data_type", :string, :null => true
    change_column  :parameters, "data_element_id",:string
    remove_column  :parameters, "data_type_id"
  end
end
