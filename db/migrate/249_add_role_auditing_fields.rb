class AddRoleAuditingFields < ActiveRecord::Migration
  def self.up
      add_column   :roles , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :roles , :updated_by_user_id,  :integer,  :default=>1,  :null=>false  
  end

  def self.down
      remove_column   :roles , :created_by_user_id
      remove_column   :roles , :updated_by_user_id
  end
end
