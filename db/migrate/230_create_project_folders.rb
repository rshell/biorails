class CreateProjectFolders < ActiveRecord::Migration
  def self.up
    create_table :project_folders do |t|
      t.column "parent_id",           :integer
      t.column "project_id",          :integer, :null => false
      t.column "type",                :string,  :default=>'ProjectElement',  :limit => 32
      t.column "position",            :integer, :default => 1
      t.column "name",                :string,  :null => false
      t.column "path",                :string,  :null => false
      t.column "reference_id",        :integer, :null => false
      t.column "reference_type",      :string,  :limit => 20
      t.column "published",           :boolean, :default => false
      t.column "content_hash",        :string
      t.column "lock_timeout",        :datetime
      t.column "lock_user_id",        :integer 
      t.column "lock_version",        :integer,   :default => 0,         :null => false
      t.column "created_by",          :integer,   :default => 1,         :null => false
      t.column "created_at",          :datetime,                         :null => false
      t.column "updated_by",          :integer,   :default => 1,         :null => false
      t.column "updated_at",          :datetime,                         :null => false
      t.column "published_at",        :datetime
      t.column "published_by",        :integer
    end
  end

  def self.down
    drop_table :project_folders
  end
end
