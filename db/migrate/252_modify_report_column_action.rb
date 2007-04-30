class ModifyReportColumnAction < ActiveRecord::Migration
  def self.up
     change_column :report_columns,   :action,  :string
  end

  def self.down
     change_column :report_columns,   :action,  :text
  end
end
