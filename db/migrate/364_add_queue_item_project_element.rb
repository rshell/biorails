class AddQueueItemProjectElement < ActiveRecord::Migration
  def self.up
    add_column :queue_items,:project_element_id,:integer
  end

  def self.down
    remove_column :queue_items,:project_element_id
  end
end
