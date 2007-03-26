##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class CreateQueueItems < ActiveRecord::Migration
  def self.up
    create_table :queue_items do |t|
      t.column "label", :string
      t.column "comments", :text      
      t.column "study_queue_id", :integer
      t.column "study_protocol_id", :integer
      t.column "experiment_id", :integer
      t.column "task_id", :integer
      t.column "status", :string
      t.column "priority", :string
      t.column "study_parameter_id",:integer
      t.column "data_element_id",:integer
      t.column "data_type", :string
      t.column "data_id", :integer
      t.column "data_name", :string
      t.column "request_by", :string, :limit => 60
      t.column "assigned_to", :string, :limit => 60
      t.column "requested_at", :datetime
      t.column "accepted_at", :datetime
      t.column "completed_at", :datetime
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "created_by", :string, :limit => 32, :default => "", :null => false
      t.column "created_at", :datetime, :null => false
      t.column "updated_by", :string, :limit => 32, :default => "", :null => false
      t.column "updated_at", :datetime, :null => false
    end
  end

  def self.down
    drop_table :queue_items
  end
end
