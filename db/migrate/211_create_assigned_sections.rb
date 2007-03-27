class CreateAssignedSections < ActiveRecord::Migration
  def self.up
    create_table :assigned_sections do |t|
      t.column "article_id", :integer
      t.column "section_id", :integer
      t.column "position",   :integer, :default => 1
    end
  end

  def self.down
    drop_table :assigned_sections
  end
end
