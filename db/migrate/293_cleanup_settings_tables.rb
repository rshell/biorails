class CleanupSettingsTables < ActiveRecord::Migration
  def self.up
    rename_column :system_settings, :text, :value
    add_column :user_settings,:user_id,:integer
    remove_column :user_settings,:description
    remove_column :system_settings,:description
  end

  def self.down
    rename_column :system_settings, :value, :text
    remove_column :user_settings,:user_id
    add_column :user_settings,:description,:string
    add_column :system_settings,:description,:string
  end
end
