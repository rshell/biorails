class CreateSections < ActiveRecord::Migration
  def self.up
    create_table "sections", :force => true do |t|
      t.column "name",                :string
      t.column "show_paged_articles", :boolean, :default => false
      t.column "articles_per_page",   :integer, :default => 15
      t.column "layout",              :string
      t.column "template",            :string
      t.column "project_id",             :integer
      t.column "path",                :string
      t.column "articles_count",      :integer, :default => 0
      t.column "archive_path",        :string
      t.column "archive_template",    :string
      t.column "position",            :integer, :default => 1
    end
  end

  def self.down
    drop_table :sections
  end
end
