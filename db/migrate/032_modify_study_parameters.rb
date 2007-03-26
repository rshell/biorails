##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

##
# Added forgotten column
#
class ModifyStudyParameters < ActiveRecord::Migration
  def self.up
    add_column  :study_parameters, "study_id", :integer, :null => true
  end

  def self.down
    remove_column  :study_parameters, "study_id"
  end
end
