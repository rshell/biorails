class CreateAsserts < ActiveRecord::Migration
  def self.up
    create_table :asserts do |t|
    t.column "project_id",       :integer
    t.column "parent_id",        :integer
    t.column "user_id",          :integer    
    t.column "title",            :string
    t.column "content_type",     :string
    t.column "filename",         :string
    t.column "size",             :integer
    t.column "thumbnail",        :string
    t.column "width",            :integer
    t.column "height",           :integer
    t.column "thumbnails_count", :integer,  :default => 0
    t.column "lock_version",      :integer,                :default => 0,             :null => false
    t.column "created_by",        :string,   :limit => 32, :default => "sys",         :null => false
    t.column "created_at",        :datetime,                                          :null => false
    t.column "updated_by",        :string,   :limit => 32, :default => "sys",         :null => false
    t.column "updated_at",        :datetime,                                          :null => false
    end
  end

  def self.down
    drop_table :asserts
  end
end
