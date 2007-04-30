class AddScheduledStatusDefaults < ActiveRecord::Migration
  def self.up
     change_column :projects,    :status_id,  :integer, :default=>0, :null => false
     change_column :studies,     :status_id,  :integer, :default=>0, :null => false
     change_column :experiments, :status_id,  :integer, :default=>0, :null => false
     change_column :tasks,       :status_id,  :integer, :default=>0, :null => false
     change_column :requests,    :status_id,  :integer, :default=>0, :null => false
     change_column :queue_items,    :status_id,  :integer, :default=>0, :null => false
     change_column :request_services,    :status_id,  :integer, :default=>0, :null => false
  end

  def self.down
  end
end
