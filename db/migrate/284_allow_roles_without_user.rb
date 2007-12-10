class AllowRolesWithoutUser < ActiveRecord::Migration
  def self.up
    change_column    :roles,   :created_by_user_id, :integer , :null => true
    change_column    :roles,   :updated_by_user_id, :integer , :null => true
  end

  def self.down
    change_column    :roles,   :created_by_user_id, :integer , :null => false
    change_column    :roles,   :updated_by_user_id, :integer , :null => false
  end
end
