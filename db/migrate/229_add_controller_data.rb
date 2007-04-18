class AddControllerData < ActiveRecord::Migration
  def self.up
    Permission.load_database
    add_column :roles_permissions, :permission_id, :integer
  end

  def self.down
    remove_column :roles_permissions, :permission_id
  end
end
