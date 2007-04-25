class CreateDbFiles < ActiveRecord::Migration
  def self.up
    create_table :db_files do |t|
      t.column "data",     :binary
    end
    add_column :project_assets,:content_data,:binary
  end

  def self.down
    drop_table :db_files
    remove_column :project_assets,:content_data
  end
end
