##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class CreateStudyQueues < ActiveRecord::Migration
  def self.up
    create_table :study_queues do |t|
      t.column "name", :string, :limit => 128, :default => "", :null => false
      t.column "description", :text      
      t.column "study_id", :integer
      t.column "study_stage_id",:integer
      t.column "study_parameter_id",:integer
      t.column "study_protocol_id", :integer
      t.column "assigned_to", :string, :limit => 60
      t.column "status", :string, :default =>'new', :null => false
      t.column "priority", :string, :default => 'normal', :null => false      
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "created_by", :string, :limit => 32, :default => "", :null => false
      t.column "created_at", :datetime, :null => false
      t.column "updated_by", :string, :limit => 32, :default => "", :null => false
      t.column "updated_at", :datetime, :null => false
    end
  end

  def self.down
    drop_table :study_queues
  end
end
