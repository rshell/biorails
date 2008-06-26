class CreateCrossTabs < ActiveRecord::Migration
  def self.up
    create_table :cross_tabs do |t|
      t.integer "project_id", :null => false
      t.integer "team_id", :null => false
      t.string  "name",                             :limit => 64,  :null => false
      t.string  "description",                      :limit => 255,  :null => false
      t.integer "lock_version",                     :default => 0, :null => false
      t.time    "created_at"
      t.integer "created_by_user_id",               :default => 1, :null => false
      t.time    "updated_at"
      t.integer "updated_by_user_id",               :default => 1, :null => false
    end  
  end

  def self.down
    drop_table :cross_tabs
  end
end
