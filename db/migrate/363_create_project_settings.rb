class CreateProjectSettings < ActiveRecord::Migration
  def self.up
  create_table "project_settings", :force => true do |t|
    t.integer  "project_id",          :default => "1", :null => false
    t.string   "name",               :limit => 30, :default => "",  :null => false
    t.string   "tip"
    t.string   "value"                            
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.integer  "updated_by_user_id",               :default => 1,   :null => false
    t.integer  "created_by_user_id",               :default => 1,   :null => false
  end

  add_index "project_settings", ["project_id", "name"], :name => "project_settings_idx1", :unique => true
  add_index "project_settings", ["name"], :name => "project_settings_idx2"
  add_index "project_settings", ["created_at"], :name => "project_settings_idx5"
  add_index "project_settings", ["updated_at"], :name => "project_settings_idx6"
  add_index "project_settings", ["updated_by_user_id"], :name => "project_settings_idx7"
  add_index "project_settings", ["created_by_user_id"], :name => "project_settings_idx8"
  end

  def self.down
    drop_table :project_settings
  end
end
