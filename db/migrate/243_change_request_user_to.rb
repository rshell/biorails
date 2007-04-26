class ChangeRequestUserTo < ActiveRecord::Migration
  def self.up
    add_column :queue_items,:requested_by_user_id,:integer,:default=>1
    add_column :queue_items,:assigned_to_user_id,:integer,:default=>1

    add_column :request_services,:requested_by_user_id,:integer,:default=>1
    add_column :request_services,:assigned_to_user_id,:integer,:default=>1

    add_column :requests, :requested_by_user_id,:integer,:default=>1

    add_column :tasks,        :assigned_to_user_id,:integer,:default=>1
    add_column :study_queues, :assigned_to_user_id,:integer,:default=>1

    remove_column :queue_items,:requested_by
    remove_column :queue_items,:assigned_to
    
    remove_column :request_services,:requested_by
    remove_column :request_services,:assigned_to
    remove_column :requests, :requested_by

    remove_column :tasks,        :assigned_to
    remove_column :study_queues, :assigned_to
  end

  def self.down
    remove_column :queue_items,:requested_by_user_id
    remove_column :queue_items,:assigned_to_user_id

    remove_column :request_services, :requested_by_user_id
    remove_column :request_services, :assigned_to_user_id
    remove_column :requests, :requested_by_user_id

    remove_column :tasks,        :assigned_to_user_id
    remove_column :study_queues, :assigned_to_user_id

    add_column :queue_items, :requested_by,:string
    add_column :queue_items, :assigned_to,:string

    add_column :request_services, :requested_by,:string
    add_column :request_services, :assigned_to, :string

    add_column :requests, :requested_by ,:string

    add_column :tasks,        :assigned_to ,:string
    add_column :study_queues, :assigned_to ,:string

  end
end
