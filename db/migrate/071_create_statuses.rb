##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :work_status do |t|
      t.column "name", :string
      t.column "description", :string
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "created_by", :string, :limit => 32, :default => "", :null => false
      t.column "created_at", :datetime, :null => false
      t.column "updated_by", :string, :limit => 32, :default => "", :null => false
      t.column "updated_at", :datetime, :null => false    end
  end

  def self.down
    drop_table :work_status
  end
end
