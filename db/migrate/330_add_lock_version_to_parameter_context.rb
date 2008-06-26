class AddLockVersionToParameterContext < ActiveRecord::Migration
  def self.up
    add_column :parameter_contexts,:lock_version,:integer,:default => 1,  :null => false
    add_column :parameter_contexts,"created_at",          :datetime
    add_column :parameter_contexts,"updated_at",          :datetime
    add_column :parameter_contexts,"updated_by_user_id",  :integer,  :default => 1,  :null => false
    add_column :parameter_contexts,"created_by_user_id",  :integer,  :default => 1,  :null => false
  end

  def self.down
    remove_column :parameter_contexts,:lock_version
    remove_column :parameter_contexts,:created_at
    remove_column :parameter_contexts,:updated_at
    remove_column :parameter_contexts,:updated_by_user_id
    remove_column :parameter_contexts,:created_by_user_id
  end
end
