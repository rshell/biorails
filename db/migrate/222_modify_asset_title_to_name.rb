class ModifyAssetTitleToName < ActiveRecord::Migration
  def self.up
     rename_column :assets, :title, :name   
     add_column    :assets, :desciption, :text   
  end

  def self.down
     rename_column :assets, :name, :title   
     remove_column :assets, :desciption
  end
end
