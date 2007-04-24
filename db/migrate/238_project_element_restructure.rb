class ProjectElementRestructure < ActiveRecord::Migration
  def self.up
     rename_column :reports, :type, :style
     add_column :reports, :internal, :boolean
     add_column :reports, :project_id,:integer
  end

  def self.down
     rename_column :reports,  :style, :type
     remove_column :reports, :internal
     remove_column :reports, :project_id
  end
end
