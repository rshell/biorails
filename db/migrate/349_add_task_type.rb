class AddTaskType < ActiveRecord::Migration
    def self.up
    add_column :tasks,:parent_id,:integer
    add_column :tasks,:type,:string,:default=>'Task'
  end

  def self.down
    remove_column :tasks,:parent_id
    remove_column :tasks,:type
  end
end
