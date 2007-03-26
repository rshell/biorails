class RequestServiceRefractor < ActiveRecord::Migration
  def self.up
    add_column 'requests', 'data_element_id', :integer    
    add_column 'requests', 'status', :string    
    add_column 'requests', 'priority', :string      
  end

  def self.down
    remove_column 'requests', 'data_element_id'    
    remove_column 'requests', 'status' 
    remove_column 'requests', 'priority'
  end
end
