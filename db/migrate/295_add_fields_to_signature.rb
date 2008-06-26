class AddFieldsToSignature < ActiveRecord::Migration
  def self.up
     add_column :signatures, :time_source, :integer
  end

  def self.down
    remove_column :signatures, :time_source
  end
end
