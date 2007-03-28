class AddSectionsAuditing < ActiveRecord::Migration

  def self.up
     add_column :sections, :parent_id, :integer   
     add_column :sections, :desciption, :text   
     add_column :sections, :lock_version, :integer, :default => 0, :null => false
     add_column :sections, :created_by, :string, :limit => 32, :default => "", :null => false
     add_column :sections, :created_at, :datetime, :null => false
     add_column :sections, :updated_by, :string, :limit => 32, :default => "", :null => false
     add_column :sections, :updated_at, :datetime, :null => false
  end

  def self.down
     remove_column :sections, :parent_id
     remove_column :sections, :desciption
     remove_column :sections, :lock_version
     remove_column :sections, :created_by
     remove_column :sections, :created_at
     remove_column :sections, :updated_by
     remove_column :sections, :updated_at
  end
  
end
