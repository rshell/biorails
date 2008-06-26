#
# Rename of 
#
class RenameProjectSummaryToDescription < ActiveRecord::Migration
  def self.up
    rename_column :projects,:summary,:description
  end

  def self.down
    rename_column :projects,:description,:summary
  end
end
