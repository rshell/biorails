##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
###
# Adding a Process Definition to make reallocation of version of process 
# used in study easier.

class AddStudyProtocolDefinitionLink < ActiveRecord::Migration
  def self.up
    add_column  :study_protocols, "process_definition_id", :integer, :null => true
  end

  def self.down
    remove_column  :study_protocols, "process_definition_id"
  end
end
