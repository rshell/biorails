class ModifyRequestServiceDateNames < ActiveRecord::Migration
  def self.up
     rename_column :request_services, :accepted_at, :started_at
     rename_column :request_services, :completed_at, :ended_at

     rename_column :queue_items, :accepted_at, :started_at
     rename_column :queue_items, :completed_at, :ended_at

  end

  def self.down
     rename_column :request_services, :started_at,:accepted_at
     rename_column :request_services, :ended_at,:completed_at
     
     rename_column :queue_items,  :started_at,:accepted_at
     rename_column :queue_items,  :ended_at,:completed_at
  end
end
