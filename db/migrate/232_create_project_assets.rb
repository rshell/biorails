class CreateProjectAssets < ActiveRecord::Migration

  def self.up
    create_table :project_assets do |t|
        t.column "project_id",  :integer
        t.column "title",       :string
        t.column :parent_id,    :integer
        t.column :content_type, :string
        t.column :filename, :string    
        t.column :thumbnail, :string 
        t.column :size,      :integer
        t.column :width,     :integer
        t.column :height,    :integer
        t.column "thumbnails_count", :integer,  :default => 0
        t.column "published",        :boolean, :default => false
        t.column "content_hash",     :string
        t.column "lock_version",     :integer,                :default => 0,             :null => false
        t.column "created_by",       :string,   :limit => 32, :default => "sys",         :null => false
        t.column "created_at",       :datetime,                                          :null => false
        t.column "updated_by",       :string,   :limit => 32, :default => "sys",         :null => false
        t.column "updated_at",       :datetime,                                          :null => false
    end
  end

  def self.down
    drop_table :project_assets
  end
end
