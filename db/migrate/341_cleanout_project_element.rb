class CleanoutProjectElement < ActiveRecord::Migration
  def self.up
    remove_column :project_elements, :previous_version
    remove_column :project_elements, :version_no
    remove_column :project_elements, :published_version_no
    remove_column :project_elements, :published_hash
  end

  def self.down
    add_column :project_elements, :previous_version, :integer
    add_column :project_elements, :version_no, :integer
    add_column :project_elements, :published_version_no, :integer
    add_column :project_elements, :published_hash, :integer
  end
end
