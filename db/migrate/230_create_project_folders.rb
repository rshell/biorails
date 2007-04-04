class CreateProjectFolders < ActiveRecord::Migration
  def self.up
    create_table :project_folders do |t|
      t.column "project_id",          :integer, :null => false
      t.column "parent_id",           :integer
      t.column "folder_type",         :string,  :limit => 20
      t.column "position",            :integer, :default => 1
      t.column "name",                :string,  :null => false
      t.column "description",         :string
      t.column "reference_id",        :integer, :null => false
      t.column "reference_type",      :string,  :limit => 20
      t.column "path",                :string,  :null => false
      t.column "layout",              :string
      t.column "template",            :string
      t.column "element_count",       :integer, :default => 0
      t.column "lock_version",        :integer,                :default => 0,             :null => false
      t.column "created_by",          :string,   :limit => 32, :default => "sys",         :null => false
      t.column "created_at",          :datetime,                                          :null => false
      t.column "updated_by",          :string,   :limit => 32, :default => "sys",         :null => false
      t.column "updated_at",          :datetime,                                          :null => false
      t.column "published_at",        :datetime
      t.column "published_by",        :string
    end
  end

  def self.down
    drop_table :project_folders
  end
end
