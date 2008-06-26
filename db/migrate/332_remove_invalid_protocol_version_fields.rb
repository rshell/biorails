#
# removed invalid fields from protocol_versions from experiment in combining
# ProcessStep with ProtocolVersion. This is now in ProcessStep table.
#
class RemoveInvalidProtocolVersionFields < ActiveRecord::Migration
  def self.up
    remove_column :protocol_versions,:expected_length
    remove_column :protocol_versions,:expected_hours_of_work
    remove_column :protocol_versions,:start_offset_hours
    remove_column :protocol_versions,:protocol_version_id
  end

  def self.down
    add_column :protocol_versions,:expected_length,:float
    add_column :protocol_versions,:expected_hours_of_work,:float
    add_column :protocol_versions,:start_offset_hours,:float
    add_column :protocol_versions,:protocol_version_id,:integer
  end
end
