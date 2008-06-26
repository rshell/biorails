class ModifyProcessStepExpectedHours < ActiveRecord::Migration

  def self.up
   rename_column :process_steps, :expected_hour, :expected_hours
  end

  def self.down
   rename_column :process_steps, :expected_hours, :expected_hour
  end
  
end
