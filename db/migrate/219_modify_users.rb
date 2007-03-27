class ModifyUsers < ActiveRecord::Migration
  def self.up
    rename_column :users,:password,:password_hash
       add_column :users, "login",            :string,   :limit => 40
       add_column :users, "activation_code",  :string,   :limit => 40
       add_column :users, "state_id",         :integer
       add_column :users, "activated_at",     :datetime
       add_column :users, "token",            :string
       add_column :users, "token_expires_at", :datetime
       add_column :users, "filter",           :string
       add_column :users, "admin",            :boolean,  :default => false   
       add_column :users, "created_at",       :datetime
       add_column :users, "updated_at",       :datetime
       add_column :users, "deleted_at",       :datetime
  end

  def self.down
       rename_column :users,:password_hash,:password
       remove_column :users, "login"
       remove_column :users, "activation_code"
       remove_column :users, "state_id"
       remove_column :users, "activated_at"
       remove_column :users, "token"
       remove_column :users, "token_expires_at"
       remove_column :users, "filter"
       remove_column :users, "admin"
       remove_column :users, "created_at"
       remove_column :users, "updated_at"
       remove_column :users, "deleted_at"
  end
end
