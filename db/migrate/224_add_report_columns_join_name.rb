class AddReportColumnsJoinName < ActiveRecord::Migration
  def self.up
      add_column :report_columns, :join_name, :string
  end

  def self.down
      remove_column :report_columns, :join_name
  end
end
