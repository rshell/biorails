class RebuildPermissions < ActiveRecord::Migration
  def self.up
    #
    # Reload permissions to match controller rules in code
    #
    Permission.load_database
  end

  def self.down
  end
end
