class CreateStateFlows < ActiveRecord::Migration
  def self.up
    create_table :state_flows do |t|
      t.string   :name
      t.string   :description
      t.integer  :lock_version,       :default => 0,  :null => false
      t.datetime :created_at,         :null => false
      t.datetime :updated_at,         :null => false
      t.integer  :updated_by_user_id, :default => 1,  :null => false
      t.integer  :created_by_user_id, :default => 1,  :null => false
    end

    add_column :project_types,:state_flow_id,:integer
    add_column :state_changes,:state_flow_id,:integer
  end

  def self.down
    drop_table :state_flows
    remove_column :project_types,:state_flow_id
    remove_column :state_changes,:state_flow_id
  end
end
