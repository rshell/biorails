class RenameProtocolVersionAnalysisId < ActiveRecord::Migration
  def self.up
    rename_column :protocol_versions,:analysis_id,:analysis_method_id
  end

  def self.down
    rename_column :protocol_versions,:analysis_method_id,:analysis_id
  end
end
