class RequestAddList < ActiveRecord::Migration
  def self.up
    add_column 'requests', 'list_id', :integer    
  end

  def self.down
    remove_column 'requests', 'list_id'
  end
end
