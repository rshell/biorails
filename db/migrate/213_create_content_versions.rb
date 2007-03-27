class CreateContentVersions < ActiveRecord::Migration
  def self.up
    create_table :content_versions do |t|
    t.column "content_id",     :integer
    t.column "version",        :integer
    t.column "article_id",     :integer
    t.column "user_id",        :integer
    t.column "title",          :string
    t.column "permalink",      :string
    t.column "excerpt",        :text
    t.column "body",           :text
    t.column "excerpt_html",   :text
    t.column "body_html",      :text
    t.column "created_at",     :datetime
    t.column "updated_at",     :datetime
    t.column "published_at",   :datetime
    t.column "author",         :string,   :limit => 100
    t.column "author_url",     :string
    t.column "author_email",   :string
    t.column "author_ip",      :string,   :limit => 100
    t.column "comments_count", :integer,                 :default => 0
    t.column "updater_id",     :integer
    t.column "versioned_type", :string,   :limit => 20
    t.column "project_id",        :integer
    t.column "approved",       :boolean,                 :default => false
    t.column "comment_age",    :integer,                 :default => 0
    t.column "filter",         :string
    t.column "user_agent",     :string
    t.column "referrer",       :string    
    end
  end

  def self.down
    drop_table :content_versions
  end
end
