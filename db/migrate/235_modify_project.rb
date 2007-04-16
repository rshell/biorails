class ModifyProject < ActiveRecord::Migration
  def self.up
    remove_column :projects, :akismet_key
    remove_column :projects, :akismet_url
    remove_column :projects, :ping_urls
    remove_column :projects, :subtitle
    remove_column :projects, :filter
    remove_column :projects, :permalink_style
    remove_column :projects, :articles_per_page
    remove_column :projects, :approve_comments
    remove_column :projects, :search_path
    remove_column :projects, :tag_path
    remove_column :projects, :search_layout
    remove_column :projects, :tag_layout
    remove_column :projects,:current_theme_path
    
    add_column :projects, :start_date,    :datetime
    add_column :projects, :end_date,      :datetime
    add_column :projects, :expected_date, :datetime    
    add_column :projects, :done_hours,     :float
    add_column :projects, :expected_hours, :float
  end

  def self.down
    add_column :projects, "akismet_key",        :string,  :limit => 100
    add_column :projects, "akismet_url",        :string
    add_column :projects, "ping_urls",          :text
    add_column :projects, "subtitle",            :string
    add_column :projects, "filter",             :string
    add_column :projects, "permalink_style",    :string
    add_column :projects, "articles_per_page",  :integer,   :default => 15
    add_column :projects, "search_path",        :string
    add_column :projects, "tag_path",           :string
    add_column :projects, "search_layout",      :string
    add_column :projects, "tag_layout",         :string
    add_column :projects, "current_theme_path", :string    
    remove_column :projects, :approve_comments, :boolaan

    remove_column :projects, :start_date
    remove_column :projects, :end_date
    remove_column :projects, :expected_date
    remove_column :projects, :expected_hours
    remove_column :projects, :done_hours
  end
end
