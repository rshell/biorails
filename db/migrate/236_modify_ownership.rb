##
# Add Owner Project to key records to goven access rights
#
class ModifyOwnership < ActiveRecord::Migration
  def self.up
    add_column :studies, :project_id, :integer
    add_column :experiments, :project_id, :integer
    add_column :tasks, :project_id, :integer
    add_column :requests, :project_id, :integer
  end

  def self.down
    remove_column :studies,     :project_id
    remove_column :experiments, :project_id
    remove_column :tasks,       :project_id
    remove_column :requests,    :project_id
  end
end
