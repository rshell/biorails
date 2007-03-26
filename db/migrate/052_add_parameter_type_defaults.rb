##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
##
# Adding default Data Type and Concept to Parameter Types
class AddParameterTypeDefaults < ActiveRecord::Migration
  def self.up
    add_column  :parameter_types, "data_concept_id", :integer, :null => true
    add_column  :parameter_types, "data_type_id", :integer, :null => true
  end

  def self.down
    remove_column  :parameter_types, "data_concept_id"
    remove_column  :parameter_types, "data_type_id"
  end
end
