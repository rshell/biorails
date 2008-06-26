class CreateProcessStepLinks < ActiveRecord::Migration
  def self.up
    create_table :process_step_links do |t|
       t.integer :from_process_step_id
       t.integer :to_process_step_id
       t.boolean :mandatory
    end
  end

  def self.down
    drop_table :process_step_links
  end
end
