class CreateProjectContents < ActiveRecord::Migration
  def self.up
    create_table :project_contents do |t|
      t.column "project_id",     :integer,  :null => false
      t.column "type",           :string,   :limit => 20
      t.column "name",           :string
      t.column "title",          :string
      t.column "body",           :text
      t.column "body_html",      :text
      t.column "author_ip",      :string,   :limit => 100
      t.column "comments_count", :integer,                 :default => 0
      t.column "comment_age",    :integer,                 :default => 0
      t.column "published",      :boolean, :default => false
      t.column "content_hash",   :string
      t.column "lock_timeout",   :datetime
      t.column "lock_user_id",   :integer 
      t.column "lock_version",   :integer,                :default => 0,             :null => false
      t.column "created_by",     :string,   :limit => 32, :default => "sys",         :null => false
      t.column "created_at",     :datetime,                                          :null => false
      t.column "updated_by",     :string,   :limit => 32, :default => "sys",         :null => false
      t.column "updated_at",     :datetime,                                          :null => false
    end
  end

  def self.down
    drop_table :project_contents
  end
end
