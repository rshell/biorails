class CreateProjectReferences < ActiveRecord::Migration
  def self.up
    execute "update project_elements set type='ProjectReference' where reference_id is not null and type='ProjectElement'"
  end

  def self.down
    execute "update project_elements set type='ProjectElement' where reference_id is not null and type='ProjectReference'"
  end
end
