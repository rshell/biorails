class AddProjectAssetCaption < ActiveRecord::Migration
  def self.up
    rename_column :project_contents,:content_data, :caption
    change_column :project_contents,:caption,:text
  end

  def self.down
    rename_column :project_contents, :caption, :content_data
  end
end
