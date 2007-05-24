class CreateContents < ActiveRecord::Migration
  def self.up
    execute "update project_elements set type='ProjectContent' where content_id is not null and type='ProjectElement'"
  end

  def self.down
    execute "update project_elements set type='ProjectElement' where content_id is not null and type='ProjectContent'"
  end
end
