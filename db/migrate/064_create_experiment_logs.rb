##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class CreateExperimentLogs < ActiveRecord::Migration
  def self.up
    create_table :experiment_logs do |t|
      t.column :experiment_id, :integer
      t.column :task_id, :integer
      t.column :user_id, :integer
      t.column :auditable_id, :integer
      t.column :auditable_type, :string
      t.column :action, :string
      t.column :name, :string
      t.column :comment, :string
      t.column :created_by, :string
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :experiment_logs
  end
end
