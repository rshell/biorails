##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class ModifyStudyParmeterDefaults < ActiveRecord::Migration
  def self.up
    add_column  :study_parameters, "default_name", :string, :null => true
    add_column  :study_parameters, "default_value", :string, :null => true
    add_column  :study_parameters, "format_regex", :string, :null => true
    add_column  :study_parameters, "data_type", :string, :null => true
  end

  def self.down
    remove_column  :study_parameters, "default_name"
    remove_column  :study_parameters, "default_value"
    remove_column  :study_parameters, "format_regex"
    remove_column  :study_parameters, "data_type"
  end

end
