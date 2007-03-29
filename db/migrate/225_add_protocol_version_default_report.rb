##
# att a default report for when this protocol is run as a task
# 
class AddProtocolVersionDefaultReport < ActiveRecord::Migration
  def self.up
    add_column :protocol_versions, :report_id, :integer
    add_column :protocol_versions, :analysis_id, :integer
  end

  def self.down
    remove_column :protocol_versions, :report_id
    remove_column :protocol_versions, :analysis_id
  end
end
