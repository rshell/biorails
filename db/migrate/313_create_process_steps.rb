class CreateProcessSteps < ActiveRecord::Migration
  def self.up
    create_table :process_steps do |t|
      t.integer "process_flow_id",      :default => 0, :null => false
      t.integer "protocol_version_id",      :default => 0, :null => false
      t.string "name"
      t.float :start_offset_hours
      t.float :end_offset_hours
      t.float :expected_hour 
      t.integer "lock_version",                     :default => 0, :null => false
      t.time    "created_at"
      t.integer "created_by_user_id",               :default => 1, :null => false
      t.time    "updated_at"
      t.integer "updated_by_user_id",               :default => 1, :null => false
    end
  end

  def self.down
    drop_table :process_steps
  end
end
