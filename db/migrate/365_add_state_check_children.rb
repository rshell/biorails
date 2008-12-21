class AddStateCheckChildren < ActiveRecord::Migration
  def self.up
    add_column :states,:check_children,:boolean,:default=>false,:nil=>false
  end

  def self.down
    remove_column :states,:check_children
  end
end
