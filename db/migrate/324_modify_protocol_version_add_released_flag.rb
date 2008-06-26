class ModifyProtocolVersionAddReleasedFlag < ActiveRecord::Migration
  def self.up
    add_column :protocol_versions, :status,:string,:default=>'new'
    execute <<SQL
    update protocol_versions  set status = 'released' 
    where exists (select 1 from study_protocols where study_protocols.current_process_id=protocol_versions.id) 
SQL
  end

  def self.down
    remove_column :protocol_versions, :status
  end
end
