##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class AddStudyParameterDataElement < ActiveRecord::Migration
  def self.up
    add_column  :study_parameters, "data_element_id", :integer, :null => true
    add_column  :study_parameters, "data_type_id", :integer, :null => true
    remove_column  :study_parameters, "data_type"
  end

  def self.down
    add_column  :study_parameters, "data_type", :string, :null => true
    remove_column  :study_parameters, "data_element_id"
    remove_column  :study_parameters, "data_type_id"
  end
end
