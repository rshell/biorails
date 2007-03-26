class QueueItemNormalization < ActiveRecord::Migration
  def self.up
    remove_column :queue_items,:status
    remove_column :queue_items,:priority
    remove_column :queue_items,:data_element_id

    remove_column :request_services,:status
    remove_column :request_services,:priority

    remove_column :requests,:status
    remove_column :requests,:priority

  end

  def self.down
    add_column :requests, :status, :string
    add_column :requests, :priority, :string

    add_column :request_services, :status, :string
    add_column :request_services, :priority, :string

    add_column :queue_items,:status, :string
    add_column :queue_items,:priority, :string
    add_column :queue_items,:data_element_id, :integer
  end
end