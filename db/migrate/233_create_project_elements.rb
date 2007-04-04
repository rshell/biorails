class CreateProjectElements < ActiveRecord::Migration
  def self.up
    create_table :project_elements do |t|
      t.column "type",                 :string,   :limit => 20
      t.column "project_id",           :integer, :null => false
      t.column "project_folder_id",    :integer, :null => false
      t.column "position",             :integer, :default => 1      
      t.column "reference_id",         :integer, :null => false
      t.column "reference_type",       :string,  :limit => 20
    end  
  end

  def self.down
    drop_table :project_elements
  end
end
