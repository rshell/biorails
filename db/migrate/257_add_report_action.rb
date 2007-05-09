class AddReportAction < ActiveRecord::Migration
  def self.up
     add_column    :reports,   :action, :string

  end

  def self.down
     remove_column :reports, :action
  end
end
