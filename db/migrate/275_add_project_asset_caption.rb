class AddProjectAssetCaption < ActiveRecord::Migration
  def self.up
    rename_column :project_assets,:content_data, :caption
    change_column :project_assets,:caption,:text
  end

  def self.down
    rename_column :project_assets, :caption, :content_data
  end
end
