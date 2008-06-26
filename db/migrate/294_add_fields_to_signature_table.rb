class AddFieldsToSignatureTable < ActiveRecord::Migration
  def self.up
    add_column :signatures, :filename, :string
    add_column :signatures, :title, :string
    add_column :signatures, :comments, :string
  end
  def self.down
     remove_column :signatures, :filename
     remove_column :signatures, :title
     remove_column :signatures, :comments
  end
end
