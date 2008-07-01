class CorrectAssayProtocolTypes < ActiveRecord::Migration
  def self.up    
    execute "update assay_protocols set type='AssayProcess' where type='StudyProcess'"
    execute "update assay_protocols set type='AssayWorkflow' where type='StudyWorkflow'"
  end

  def self.down
    execute "update assay_protocols set type='StudyProcess' where type='AssayProcess'"
    execute "update assay_protocols set type='StudyWorkflow' where type='AssayWorkflow'"
  end
end
