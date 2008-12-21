class Database31Cleanup < ActiveRecord::Migration
  def self.up
    #
    # remove team where not needed
    #
    remove_column( :project_elements, :team_id)  if ProjectElement.column_names.any?{|i|i=='team_id'}
    remove_column( :requests,         :team_id)  if Request.column_names.any?{|i|i=='team_id'}
    remove_column( :cross_tabs,       :team_id)  if CrossTab.column_names.any?{|i|i=='team_id'}
    remove_column( :memberships,       :role_id) if Membership.column_names.any?{|i|i=='role_id'}
    rename_column( :states,:level,    :level_no) if State.column_names.any?{|i|i=='level'}
  end

  def self.down
    add_column :project_elements,:team_id,:integer
    add_column :requests,:team_id,:integer
    add_column :cross_tabs,:team_id,:integer
    add_column :memberships, :role_id,:integer
    
    rename_column :states,:level_no,:level
  end
end
