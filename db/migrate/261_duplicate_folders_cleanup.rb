#
# Looks like some development muck with folder in other projects linked to a item
#
class DuplicateFoldersCleanup < ActiveRecord::Migration
  def self.up

     execute <<SQL
delete from project_elements 
where exists (select 1 from experiments e
              where e.id = project_elements.reference_id 
              and e.project_id != project_elements.project_id
              and project_elements.reference_type='Experiment')
SQL

     execute <<SQL
delete from project_elements 
where exists (select 1 from tasks x
              where x.id = project_elements.reference_id 
              and x.project_id != project_elements.project_id
              and project_elements.reference_type='Task')
SQL

     execute <<SQL
delete from project_elements 
where exists (select 1 from studies x
              where x.id = project_elements.reference_id 
              and x.project_id != project_elements.project_id
              and project_elements.reference_type='Study')
SQL

     execute <<SQL
delete from project_elements 
where exists (select 1 from requests x
              where x.id = project_elements.reference_id 
              and x.project_id != project_elements.project_id
              and project_elements.reference_type='Request')
SQL

  end

  def self.down
  end
end
