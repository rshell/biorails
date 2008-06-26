class FixMissingColumnInSignatures < ActiveRecord::Migration
  def self.up
    begin
    rename_column :signatures, :signer, :user_id
    rescue
    p 'not everyone has this column wrongly named'
    end 
  end

  def self.down
  end
end
