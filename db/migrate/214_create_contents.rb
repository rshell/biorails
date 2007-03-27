class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.column "article_id",     :integer
      t.column "user_id",        :integer
      t.column "title",          :string
      t.column "permalink",      :string
      t.column "excerpt",        :text
      t.column "body",           :text
      t.column "excerpt_html",   :text
      t.column "body_html",      :text
      t.column "type",           :string,   :limit => 20
      t.column "author",         :string,   :limit => 100
      t.column "author_url",     :string
      t.column "author_email",   :string
      t.column "author_ip",      :string,   :limit => 100
      t.column "comments_count", :integer,                 :default => 0
      t.column "updater_id",     :integer
      t.column "version",        :integer
      t.column "project_id",        :integer
      t.column "approved",       :boolean,                 :default => false
      t.column "comment_age",    :integer,                 :default => 0
      t.column "filter",         :string
      t.column "user_agent",     :string
      t.column "referrer",       :string
      t.column "lock_version",      :integer,                :default => 0,             :null => false
      t.column "created_by",        :string,   :limit => 32, :default => "sys",         :null => false
      t.column "created_at",        :datetime,                                          :null => false
      t.column "updated_by",        :string,   :limit => 32, :default => "sys",         :null => false
      t.column "updated_at",        :datetime,                                          :null => false
      t.column "published_at",   :datetime
      t.column "published_by",     :string
    end
  end

  def self.down
    drop_table :contents
  end
end
