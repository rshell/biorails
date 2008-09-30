class CombineProjectAssetAndContent < ActiveRecord::Migration
  def self.up
    add_column :project_contents,:content_type,:string
    add_column :project_contents,:content_size,:integer   
    add_column :project_contents,:db_file_id,:integer
    
    remove_column :project_contents,:comments_count
    remove_column :project_contents,:comment_age
  end

  def self.down
    remove_column :project_contents,:content_type
    remove_column :project_contents,:content_size
    remove_column :project_contents,:db_file_id
    
    add_column :project_contents,:comments_count,:integer
    add_column :project_contents,:comment_age,:integer
  end
end
