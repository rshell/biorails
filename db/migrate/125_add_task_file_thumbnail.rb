##
# Adding ability to have thumbnails and file system storage
#
class AddTaskFileThumbnail < ActiveRecord::Migration
  def self.up
      add_column :task_files, :content_type, :string
      add_column :task_files, :parent_id,  :integer
      add_column :task_files, :filename, :string    
      add_column :task_files, :thumbnail, :string 
      add_column :task_files, :size, :integer
      add_column :task_files, :width, :integer
      add_column :task_files, :height, :integer
  end

  def self.down
      remove_column :task_files, :content_type     
      remove_column :task_files, :parent_id
      remove_column :task_files, :filename    
      remove_column :task_files, :thumbnail
      remove_column :task_files, :size
      remove_column :task_files, :width
      remove_column :task_files, :height
  end
end
