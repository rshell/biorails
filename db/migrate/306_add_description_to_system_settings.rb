class AddDescriptionToSystemSettings < ActiveRecord::Migration
  def self.up
    add_column :system_settings, :tip, :string
     add_column :user_settings, :tip, :string
  end

  def self.down
    remove_column :system_settings, :tip
    remove_column :user_settings, :tip
  end
end
