class AddControllerData < ActiveRecord::Migration
  def self.up
    Permission.rebuild
    add_column :role_permissions, :permission_id, :integer
    execute 'update role_permissions r set permission_id = (select id from permissions p where r.action = p.action and r.subject = p.subject)'
  end

  def self.down
    remove_column :role_permissions, :permission_id
    execute 'delete from permissions'
  end
end
