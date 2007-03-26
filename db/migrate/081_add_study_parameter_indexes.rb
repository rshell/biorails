##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class AddStudyParameterIndexes < ActiveRecord::Migration
  def self.up
    add_index "study_parameters", ["study_id"]
    add_index "study_parameters", ["default_name"]
    add_index "study_parameters", ["parameter_type_id"]
    add_index "study_parameters", ["parameter_role_id"]
  end

  def self.down
    remove_index "study_parameters", ["study_id"]
    remove_index "study_parameters", ["default_name"]
    remove_index "study_parameters", ["parameter_type_id"]
    remove_index "study_parameters", ["parameter_role_id"]
  end
end
