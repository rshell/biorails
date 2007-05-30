class AddProjectAssetCaption < ActiveRecord::Migration
  def self.up
    rename_column :project_content,:content_data, :caption
    change_column :project_content,:caption,:text
  end

  def self.down
    rename_column :project_content, :caption, :content_data
  end
end
