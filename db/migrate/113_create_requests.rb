class CreateRequests < ActiveRecord::Migration
  def self.up
    create_table :requests do |t|
      t.column "name", :string, :limit => 128, :default => "", :null => false
      t.column "description", :text      
      t.column "requested_by", :string      
      t.column "requested_for", :string      
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "created_by", :string, :limit => 32, :default => "", :null => false
      t.column "created_at", :datetime, :null => false
      t.column "updated_by", :string, :limit => 32, :default => "", :null => false
      t.column "updated_at", :datetime, :null => false
    end
  end

  def self.down
    drop_table :requests
  end
end
