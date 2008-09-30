class AddProjectElementStyleFk < ActiveRecord::Migration
  def self.up
    add_column :project_elements,:element_type_id,:integer
    execute "update project_elements set element_type_id=1 where type='ProjectContent'"
    execute "update project_elements set element_type_id=2 where type='ProjectAsset'"
    execute "update project_elements set element_type_id=3 where type='ProjectReference'"
    execute "update project_elements set element_type_id=4 where type='ProjectFolder'"
  end

  
  def self.down
   remove_column :project_elements,:element_type_id
  end
end
