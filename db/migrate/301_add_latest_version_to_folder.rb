class AddLatestVersionToFolder < ActiveRecord::Migration
  def self.up
    add_column :project_elements, :published_version_no, :integer, :default=>0, :null=>false
    add_column :project_elements, :version_no, :integer, :default=>0, :null=>false
    add_column :project_elements, :previous_version, :integer, :default=>0, :null=>false
  end

  def self.down
    remove_column :project_elements, :published_version_no
    remove_column :project_elements, :version_no
    remove_column :project_elements, :previous_version
  end
end
