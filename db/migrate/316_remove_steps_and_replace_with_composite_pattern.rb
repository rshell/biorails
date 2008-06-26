class RemoveStepsAndReplaceWithCompositePattern < ActiveRecord::Migration
  def self.up

      drop_table :process_steps
       drop_table :process_step_links
       add_column :protocol_versions, :expected_length, :float, :default=>0.0
       add_column :protocol_versions, :expected_hours_of_work, :float, :default=>0.0
       add_column :protocol_versions, :start_offset_hours, :float, :default=>0.0
  
       
  end

  def self.down
    
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
      create_table :process_step_links do |t|
         t.integer :from_process_step_id
         t.integer :to_process_step_id
         t.boolean :mandatory
      end
    remove_column :protocol_versions, :expected_length
     remove_column :protocol_versions, :expected_hours_of_work
     remove_column :protocol_versions, :start_offset_hours

  end
end
