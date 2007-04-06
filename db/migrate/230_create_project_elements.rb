class CreateProjectElements < ActiveRecord::Migration
  def self.up
    create_table :project_elements do |t|
      t.column "parent_id",           :integer
      t.column "project_id",          :integer, :null => false
      t.column "type",                :string,  :default=>'ProjectElement',  :limit => 32
      t.column "position",            :integer, :default => 1
      t.column "name",                :string,  :null => false,  :limit => 64
      t.column "path",                :string,  :null => false,  :limit => 255
      t.column "reference_id",        :integer 
      t.column "reference_type",      :string,  :limit => 20
      t.column "lock_version",        :integer,   :default => 0,         :null => false
      t.column "created_by",          :integer,   :default => 1,         :null => false
      t.column "created_at",          :datetime,                         :null => false
      t.column "updated_by",          :integer,   :default => 1,         :null => false
      t.column "updated_at",          :datetime,                         :null => false
    end
  end

  def self.down
    drop_table :project_elements
  end
end
