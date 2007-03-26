class AddListDataElement < ActiveRecord::Migration
  def self.up
    add_column    :lists,  "data_element_id", :integer
  end

  def self.down
    remove_column    :lists,  "data_element_id"
  end
end
