class AddPublishedStatusToProjectElement < ActiveRecord::Migration
  def self.up
    add_column :project_elements,:state_id,:integer
  end

  def self.down
    remove_column :project_elements,:state_id
  end
end
