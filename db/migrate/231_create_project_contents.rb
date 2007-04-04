class CreateProjectContents < ActiveRecord::Migration
  def self.up
    create_table :project_contents do |t|
      t.column "project_id",     :integer
      t.column "name",           :string
      t.column "title",          :string
      t.column "excerpt",        :text
      t.column "body",           :text
      t.column "excerpt_html",   :text
      t.column "body_html",      :text
      t.column "type",           :string,   :limit => 20
      t.column "author_ip",      :string,   :limit => 100
      t.column "comments_count", :integer,                 :default => 0
      t.column "comment_age",    :integer,                 :default => 0
      t.column "approved",       :boolean,                 :default => false
      t.column "lock_version",   :integer,                :default => 0,             :null => false
      t.column "created_by",     :string,   :limit => 32, :default => "sys",         :null => false
      t.column "created_at",     :datetime,                                          :null => false
      t.column "updated_by",     :string,   :limit => 32, :default => "sys",         :null => false
      t.column "updated_at",     :datetime,                                          :null => false
      t.column "published_by",   :string
      t.column "published_at",   :datetime
    end
  end

  def self.down
    drop_table :project_contents
  end
end
