##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class CreateTaskFiles < ActiveRecord::Migration
  def self.up
    create_table :task_files do |t|
      t.column "task_context_id", :integer
      t.column "parameter_id",:integer
      t.column "data_uri", :double    
      t.column "is_external", :boolean 
      t.column "mime_type", :string, :limit=>250
      t.column "data_binary", :text
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "created_by", :string, :limit => 32, :default => "", :null => false
      t.column "created_at", :datetime, :null => false
      t.column "updated_by", :string, :limit => 32, :default => "", :null => false
      t.column "updated_at", :datetime, :null => false
    end
  end

  def self.down
    drop_table :task_files
  end
end
