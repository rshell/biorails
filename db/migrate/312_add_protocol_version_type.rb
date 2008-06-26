class AddProtocolVersionType < ActiveRecord::Migration
  def self.up
    add_column :protocol_versions,:type,:string,:default => 'ProcessInstance'
  end

  def self.down
    remove_column :protocol_versions,:type
  end
end
