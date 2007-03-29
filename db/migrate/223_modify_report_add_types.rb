class ModifyReportAddTypes < ActiveRecord::Migration
  def self.up
     add_column    :reports, :type, :string ,:default=>'Report'  
  end

  def self.down
     remove_column :reports, :type
  end
end
