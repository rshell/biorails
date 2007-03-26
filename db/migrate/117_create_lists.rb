class CreateLists < ActiveRecord::Migration
  def self.up
    create_table :lists do |t|
      t.column "name", :string
      t.column "description", :text      
      t.column "type", :string
      t.column "expires_at", :datetime
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "created_by", :string, :limit => 32, :default => "", :null => false
      t.column "created_at", :datetime, :null => false
      t.column "updated_by", :string, :limit => 32, :default => "", :null => false
      t.column "updated_at", :datetime, :null => false    end
  end

  def self.down
    drop_table :lists
  end
end
