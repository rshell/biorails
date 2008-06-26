class RemoveDefaultUserValuesFromRequest < ActiveRecord::Migration
  def self.up
       change_column  :requests, :updated_by_user_id, :integer, :default => false
       change_column  :requests, :created_by_user_id, :integer, :default => false
       change_column  :requests, :requested_by_user_id, :integer, :default => false
  end
  
  def self.down
       change_column  :requests, :updated_by_user_id, :integer, :default => 1
       change_column  :requests, :created_by_user_id, :integer, :default => 1
       change_column  :requests, :requested_by_user_id, :integer, :default => 1
  end
end