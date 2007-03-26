class CreateRequestServices < ActiveRecord::Migration
  def self.up
    create_table :request_services do |t|
      t.column "request_id", :integer,:null => false
      t.column "service_id",  :integer,:null => false
      t.column "status",:string,:limit => 32, :default => "new", :null => false
      t.column "priority",:string,:limit => 32, :default => "normal", :null => false
      t.column "name", :string, :limit => 128, :default => "", :null => false
      t.column "description", :text      
      t.column "requested_by", :string , :limit => 60     
      t.column "requested_for", :datetime    
      t.column "assigned_to", :string, :limit => 60
      t.column "accepted_at", :datetime
      t.column "completed_at", :datetime           
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "created_by", :string, :limit => 32, :default => "", :null => false
      t.column "created_at", :datetime, :null => false
      t.column "updated_by", :string, :limit => 32, :default => "", :null => false
      t.column "updated_at", :datetime, :null => false
    end
  end

  def self.down
    drop_table :request_services
  end
end
