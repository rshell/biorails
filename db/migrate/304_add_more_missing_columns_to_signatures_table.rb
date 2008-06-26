class AddMoreMissingColumnsToSignaturesTable < ActiveRecord::Migration
  def self.up
    begin
    add_column :signatures, :created_at, :datetime
    add_column :signatures, :created_by_user_id, :int
    add_column :signatures, :updated_at, :datetime
    add_column :signatures, :updated_by_user_id, :int
    add_column :signatures, :comments, :string
    remove_column :signatures, :comment
  rescue
    p 'not everyone needs this migration'
  end
  end

  def self.down
  end
end
