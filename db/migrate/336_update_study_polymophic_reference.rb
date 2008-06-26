class UpdateStudyPolymophicReference < ActiveRecord::Migration
  def self.up
     execute "update project_elements set reference_type='Assay'          where reference_type='Study'"
     execute "update project_elements set reference_type='AssayParameter' where reference_type='StudyParameter'"
     execute "update project_elements set reference_type='AssayQueue'     where reference_type='StudyQueue'"
     execute "update project_elements set reference_type='AssayProtocol'  where reference_type='StudyProtocol'"
     execute "update project_elements set reference_type='AssayProcess'   where reference_type='StudyProcess'"
     execute "update project_elements set reference_type='AssayWorkflow'  where reference_type='StudyWorkfow'"
  end

  def self.down
     execute "update project_elements set reference_type='Study'          where reference_type='Assay'"
     execute "update project_elements set reference_type='StudyParameter' where reference_type='AssayParameter'"
     execute "update project_elements set reference_type='StudyQueue'     where reference_type='AssayQueue'"
     execute "update project_elements set reference_type='StudyProtocol'  where reference_type='AssayProtocol'"
     execute "update project_elements set reference_type='StudyProcess'   where reference_type='AssayProcess'"
     execute "update project_elements set reference_type='StudyWorkflow'  where reference_type='AssayWorkfow'"
  end
end
