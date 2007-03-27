class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
    t.column "name",          :string,   :limit => 30, :default => "",   :null => false
    t.column "summary",       :text,      :default => "",   :null => false
    t.column "status_id",      :integer,                :default => 0,             :null => false
    t.column "title",             :string
    t.column "subtitle",          :string
    t.column "email",              :string
    t.column "ping_urls",          :text
    t.column "articles_per_page",  :integer,                :default => 15
    t.column "host",               :string
    t.column "akismet_key",        :string,  :limit => 100
    t.column "akismet_url",        :string
    t.column "approve_comments",   :boolean
    t.column "comment_age",        :integer
    t.column "timezone",           :string
    t.column "filter",             :string
    t.column "permalink_style",    :string
    t.column "search_path",        :string
    t.column "tag_path",           :string
    t.column "search_layout",      :string
    t.column "tag_layout",         :string
    t.column "current_theme_path", :string    
    t.column "created_by",     :string,   :limit => 32, :default => "sys",         :null => false
    t.column "created_at",     :datetime,                                          :null => false
    t.column "updated_by",      :string,   :limit => 32, :default => "sys",         :null => false
    t.column "updated_at",      :datetime,                                          :null => false
    end
  end

  def self.down
    drop_table :projects
  end
end
