class CreateCachedPages < ActiveRecord::Migration
  def self.up
    create_table :cached_pages do |t|
      t.column "url",        :string
      t.column "references", :text
      t.column "updated_at", :datetime
      t.column "project_id",    :integer
      t.column "cleared_at", :datetime 
   end
  end

  def self.down
    drop_table :cached_pages
  end
end
