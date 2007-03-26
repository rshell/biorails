##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class CreateExperiments < ActiveRecord::Migration
  def self.up
    create_table :experiments do |t|
      t.column "name", :string, :limit => 128, :default => "", :null => false
      t.column "description", :text
      t.column "category_id", :integer
      t.column "status_id", :string
      t.column "study_id", :integer
      t.column "default_protocol_id", :integer
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "created_by", :string, :limit => 32, :default => "", :null => false
      t.column "created_at", :datetime, :null => false
      t.column "updated_by", :string, :limit => 32, :default => "", :null => false
      t.column "updated_at", :datetime, :null => false
    end
  end

  def self.down
    drop_table :experiments
  end
end
