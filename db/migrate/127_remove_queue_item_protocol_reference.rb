class RemoveQueueItemProtocolReference < ActiveRecord::Migration
  def self.up
      remove_column :queue_items, :study_protocol_id  
  end

  def self.down
      add_column :queue_items, :study_protocol_id,:integer  
  end
end
