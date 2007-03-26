##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class AddStudyProtocolIndexes < ActiveRecord::Migration
  def self.up
    add_index "study_protocols", ["study_id"]
    add_index "study_protocols", ["process_instance_id"]
    add_index "study_protocols", ["process_definition_id"]
  end

  def self.down
    remove_index "study_protocols", ["study_id"]
    remove_index "study_protocols", ["process_instance_id"]
    remove_index "study_protocols", ["process_definition_id"]
  end
end
