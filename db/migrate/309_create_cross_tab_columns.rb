class CreateCrossTabColumns < ActiveRecord::Migration
  def self.up
    create_table :cross_tab_columns do |t|
      t.integer "cross_tab_id", :null => false
      t.string  "name",                              :limit => 64
      t.string  "title",                             :limit => 64
      t.integer "parameter_id"
      t.integer "study_parameter_id", :null => false
      t.integer "parameter_type_id", :null => false
      t.integer "lock_version",                     :default => 0, :null => false
      t.time    "created_at"
      t.integer "created_by_user_id",               :default => 1, :null => false
      t.time    "updated_at"
      t.integer "updated_by_user_id",               :default => 1, :null => false
    end
  end

  def self.down
    drop_table :cross_tab_columns
  end
end
