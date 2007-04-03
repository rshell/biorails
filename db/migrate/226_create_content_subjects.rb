class CreateContentSubjects < ActiveRecord::Migration
  def self.up
    create_table :content_subjects do |t|
       t.column "content_id",   :integer
       t.column "subject_type", :string
       t.column "subject_id",   :integer
    end
  end

  def self.down
    drop_table :content_subjects
  end
end
