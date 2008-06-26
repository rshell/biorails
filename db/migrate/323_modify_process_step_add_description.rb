class ModifyProcessStepAddDescription < ActiveRecord::Migration
  def self.up
    add_column :process_steps, :description,:string
  end

  def self.down
    remove_column :process_steps, :description  
  end
end
