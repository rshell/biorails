class ModifyQueueItem < ActiveRecord::Migration
  def self.up
    rename_column :queue_items,  "label", "name"
    rename_column :queue_items,  "requested_at", "requested_for"
    rename_column :queue_items,  "request_by",   "requested_by"
    add_column    :queue_items,  "request_service_id", :integer
  end

  def self.down
    remove_column :queue_items,   "request_service_id"
    rename_column :queue_items,   "name","label"
    rename_column :queue_items,   "requested_for","requested_at"
    rename_column :queue_items,   "requested_by", "request_by"
  end
end
