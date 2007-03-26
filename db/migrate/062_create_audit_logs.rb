##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class CreateAuditLogs < ActiveRecord::Migration
  def self.up
    create_table :audit_logs do |t|
      t.column :auditable_id, :integer
      t.column :auditable_type, :string
      t.column :user_id, :integer
      t.column :action, :string
      t.column :changes, :text
      t.column :created_by, :string
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :audit_logs
  end
end
