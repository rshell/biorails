class AddAuditingToUsers < ActiveRecord::Migration
  def self.up
      add_column   :users , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :users , :updated_by_user_id,  :integer,  :default=>1,  :null=>false  
  end

  def self.down
      remove_column   :users , :created_by_user_id
      remove_column   :users , :updated_by_user_id
  end
end
