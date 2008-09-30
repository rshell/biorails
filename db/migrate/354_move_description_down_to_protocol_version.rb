class MoveDescriptionDownToProtocolVersion < ActiveRecord::Migration
  def self.up
    add_column :protocol_versions, :description, :string
    execute <<SQL
    update protocol_versions set description = (
      select description from assay_protocols 
      where protocol_versions.assay_protocol_id = assay_protocols.id)
SQL
  end

  def self.down
    remove_column :protocol_versions, :description
  end
end
