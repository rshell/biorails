##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

class CreateStudyProtocols < ActiveRecord::Migration
  def self.up
    create_table :study_protocols, :force => true do |t|
      t.column "study_id",            :integer, :null => false
      t.column "study_stage_id",      :integer, :default => 1, :null => false
      t.column "process_instance_id", :integer, :null => false
    end
  end

  def self.down
    drop_table :study_protocols
  end
end
