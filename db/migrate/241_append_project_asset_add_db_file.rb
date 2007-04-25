class AppendProjectAssetAddDbFile < ActiveRecord::Migration
  def self.up
    add_column :project_assets,:db_file_id, :integer
  end

  def self.down
    remove_column :project_assets,:db_file_id
  end
end
