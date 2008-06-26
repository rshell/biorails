class RenameProjectElementColumn < ActiveRecord::Migration
def self.up
  add_column :users, :private_key, :binary
  begin
  rename_column :signatures, :project_element, :project_element_id
  
  rescue
  p 'not everyone has this column wrongly named'
  end
end
  def self.down

    #remove_column :users, :private_key
  end
end
