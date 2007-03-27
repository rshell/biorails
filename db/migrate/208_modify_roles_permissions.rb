class ModifyRolesPermissions < ActiveRecord::Migration
  def self.up
       add_column :roles_permissions, "subject", :string,   :limit => 40
       add_column :roles_permissions, "action", :string,   :limit => 40
  end

  def self.down
       remove_column :roles_permissions, "subject"
       remove_column :roles_permissions, "action"
  end
end
