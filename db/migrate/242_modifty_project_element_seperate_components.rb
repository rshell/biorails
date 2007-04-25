class ModiftyProjectElementSeperateComponents < ActiveRecord::Migration
  def self.up
     add_column :project_elements, :asset_id,:integer
     add_column :project_elements, :content_id, :integer
     add_column :project_elements, :published_hash,   :string    
  end

  def self.down
     remove_column :project_elements, :asset_id
     remove_column :project_elements, :content_id
     remove_column :project_elements, :published_hash   
  end
  
end
