class AddProjectElementTitle < ActiveRecord::Migration
  def self.up
    add_column :project_elements,:title,:string
    
    execute <<SQL
update project_elements e 
   set e.title = (select c.title from project_contents c where c.id=e.content_id)
   where e.title is null 
SQL
    
    execute <<SQL
update project_elements e 
   set e.title = (select a.title from project_assets a where a.id=e.content_id)
   where e.title is null 
SQL

  end

  def self.down
    remove_column :project_elements, :title
  end
  
end
