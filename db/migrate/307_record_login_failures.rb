class RecordLoginFailures < ActiveRecord::Migration
  def self.up
    add_column :users, :login_failures, :integer, :default=>0,  :null => false
  end

  def self.down
    remove_column :users, :login_failures
  end
end
