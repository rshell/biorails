class AddProtocolVersionExceptedHours < ActiveRecord::Migration
  def self.up
    add_column :protocol_versions, :expected_hours,:float, :default => '24' ,:null => false
  end

  def self.down
    remove_column :protocol_versions, :expected_hours  
  end

end
