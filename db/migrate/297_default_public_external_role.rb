class DefaultPublicExternalRole < ActiveRecord::Migration
  def self.up
       change_column  :teams, :public_role_id, :integer, :default => 1
       change_column  :teams, :external_role_id, :integer, :default => 1  
  end
  
  def self.down
       change_column  :teams, :public_role_id, :integer, :default => false
       change_column  :teams, :external_role_id, :integer,  :default => false
  end
end