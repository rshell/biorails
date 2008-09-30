class Database31Cleanup < ActiveRecord::Migration
  def self.up
    #
    # remove team where not needed
    #
    remove_column :project_elements, :team_id
    remove_column :requests,         :team_id
    remove_column :cross_tabs,       :team_id
    remove_column :memberships,       :role_id
    rename_column :states,:level,    :level_no
  end

  def self.down
    add_column :project_elements,:team_id,:integer
    add_column :requests,:team_id,:integer
    add_column :cross_tabs,:team_id,:integer
    add_column :memberships, :role_id,:integer
    
    rename_column :states,:level_no,:level
  end
end
