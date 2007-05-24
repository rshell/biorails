class ProjectElementCount < ActiveRecord::Migration
  def self.up
    add_column    :project_elements,   project_elements_count, :integer ,:default=>0,:null => false
     execute 'create table tmp as select x.parent_id,count(*) num from project_elements x group by x.parent_id '
     execute 'update project_elements set project_elements_count  = (select num from tmp x where x.parent_id = project_elements.id )'
     execute 'drop table tmp'
  end

  def self.down
     remove_column :project_elements
  end
end
