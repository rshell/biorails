class RemoveProjectElementPath < ActiveRecord::Migration
  def self.up
     remove_column :project_elements, :path
  end

  def self.down
     add_column    :project_elements,  :path, :string
  end
end
