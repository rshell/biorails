class CreateElementTypes < ActiveRecord::Migration
  def self.up
    create_table :element_types do |t|
      t.string "name",                :limit => 30,  :default => "", :null => false
      t.string "description",         :limit => 255, :default => "_show", :null => false
      t.string "class_name",          :limit => 255, :default => 0,  :null => false
      t.integer "publish_to_team_id",                :default => 1,  :null => false
      t.datetime "created_at",             :null => false
      t.integer "created_by_user_id",      :default => 1,  :null => false      
      t.datetime "updated_at",             :null => false
      t.integer "updated_by_user_id",      :default => 1,  :null => false   
    end
  end

  def self.down
    drop_table :element_types
  end
end
