class ContentAddNestedTreeRebuild < ActiveRecord::Migration
  def self.up
   remove_column    :project_contents,   :scope_id   
   execute 'delete from project_contents where not exists (select 1 from project_elements e where e.content_id = project_contents.id)'
   execute 'delete from project_assets where not exists (select 1 from project_elements e where e.asset_id = project_assets.id)'
   Content.rebuild_sets
  end

  def self.down
    add_column    :project_contents,   :scope_id, :integer 
  end
end
