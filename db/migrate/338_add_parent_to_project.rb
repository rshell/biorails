class AddParentToProject < ActiveRecord::Migration
  def self.up
    add_column :projects,:parent_id,:integer, :null => true
  end

  def self.down
    remove_column :projects,:parent_id
  end
end
