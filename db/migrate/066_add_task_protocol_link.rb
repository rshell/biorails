##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class AddTaskProtocolLink < ActiveRecord::Migration

  def self.up
    add_column  :experiments, "study_protocol_id", :integer
    add_column  :tasks, "study_protocol_id", :integer
    rename_column :experiments,'default_protocol_id','process_instance_id'
    
  end

  def self.down
    remove_column  :experiments, "study_protocol_id"
    remove_column  :tasks, "study_protocol_id"
    rename_column :experiments,'process_instance_id','default_protocol_id'
  end
  
end
