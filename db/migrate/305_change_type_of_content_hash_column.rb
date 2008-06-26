class ChangeTypeOfContentHashColumn < ActiveRecord::Migration
  def self.up
    remove_column :signatures, :content_hash
    add_column :signatures, :content_hash, :text
  end

  def self.down
    remove_column :signatures, :content_hash
    add_column :signatures, :content_hash, :string
  end
end
