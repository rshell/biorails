class ConsolidateStatusHandling < ActiveRecord::Migration
  def self.up
    add_column :queue_items,:status_id,:integer
    add_column :queue_items,:priority_id,:integer

    add_column :request_services,:status_id,:integer
    add_column :request_services,:priority_id,:integer

    add_column :requests,:status_id,:integer
    add_column :requests,:priority_id,:integer

    change_column :tasks, :status_id, :integer
  end

  def self.down
    remove_column :queue_items,:status_id
    remove_column :queue_items,:priority_id

    remove_column :request_services,:status_id
    remove_column :request_services,:priority_id

    remove_column :requests,:status_id
    remove_column :requests,:priority_id

    change_column :tasks, :status_id, :string
  end
end
