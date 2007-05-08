class NewProjectBusinessRules < ActiveRecord::Migration
  def self.up
     ##
     # Fill in the muissing keys to project and protcools
     #
     execute 'update experiments e set e.project_id = (select s.project_id from studies s where s.id =e.study_id) where e.project_id is null'
     execute 'update tasks t set t.project_id = (select e.project_id from experiments e where e.id =t.experiment_id) where t.project_id is null'
     execute 'update experiments e set e.protocol_version_id = (select max(t.protocol_version_id) from tasks t where e.id =t.experiment_id) where e.protocol_version_id is null'
     execute 'update experiments e set e.study_protocol_id = (select max(t.study_protocol_id) from tasks t where e.id =t.experiment_id) where e.study_protocol_id is null'
     ##
     # Remove tasks and experiments without a protocol 
     #
     execute 'delete from tasks where experiment_id in (select e.id from experiments e  where (e.protocol_version_id is null or e.study_protocol_id is null))'
     execute 'delete from experiments  where protocol_version_id is null or study_protocol_id is null'

     change_column :experiments,:project_id,:integer, :null=>false
     change_column :experiments,:study_id,:integer, :null=>false
     change_column :experiments,:study_protocol_id,:integer, :null=>false

     change_column :tasks      ,:project_id,:integer, :null=>false
     change_column :tasks      ,:protocol_version_id,:integer, :null=>false
     change_column :tasks      ,:experiment_id,:integer, :null=>false

     change_column :studies    ,:project_id,:integer, :null=>false
  end   

  def self.down
  end
end
