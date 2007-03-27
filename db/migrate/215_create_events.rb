class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
       t.column "project_id",    :integer
       t.column "user_id",    :integer
       t.column "article_id", :integer
       t.column "mode",       :string
       t.column "title",      :text
       t.column "body",       :text
       t.column "author",     :string,   :limit => 100
       t.column "comment_id", :integer
       t.column "lock_version",      :integer,                :default => 0,             :null => false
       t.column "created_by",        :string,   :limit => 32, :default => "sys",         :null => false
       t.column "created_at",        :datetime,                                          :null => false
       t.column "updated_by",        :string,   :limit => 32, :default => "sys",         :null => false
       t.column "updated_at",        :datetime,                                          :null => false
     end
  end

  def self.down
    drop_table :events
  end
end
