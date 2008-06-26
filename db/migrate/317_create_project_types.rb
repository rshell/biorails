class CreateProjectTypes < ActiveRecord::Migration
  def self.up
    create_table :project_types do |t|
      t.string "name",                :limit => 30,  :default => "", :null => false
      t.string "description",         :limit => 255, :default => "_show", :null => false
      t.string "dashboard",           :limit => 255, :default => 0,  :null => false
      t.integer "publish_to_team_id",                :default => 1,  :null => false
      t.integer "lock_version",                      :default => 0,  :null => false
      t.datetime "created_at",             :null => false
      t.integer "created_by_user_id",      :default => 1,  :null => false      
      t.datetime "updated_at",             :null => false
      t.integer "updated_by_user_id",      :default => 1,  :null => false   
    end    
  end  

  def self.down
    drop_table :project_types
  end
end
