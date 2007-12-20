class AddAssertedTextToSignatureModel < ActiveRecord::Migration
  def self.up
    add_column :signatures, :asserted_text, :string
  end

  def self.down
    remove_column :signatures, :asserted_text
  end
end
