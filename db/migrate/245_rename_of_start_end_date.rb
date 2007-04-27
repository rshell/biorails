##
# changing start_date/end_date to started_at/ended_at to allow for time bases scheduling and
# make names consistent
# 
class RenameOfStartEndDate < ActiveRecord::Migration
  def self.up
     rename_column :projects, :start_date, :started_at
     rename_column :projects, :end_date, :ended_at

     rename_column :tasks, :start_date, :started_at
     rename_column :tasks, :end_date, :ended_at
     
     add_column :experiments, :started_at, :datetime
     add_column :experiments, :ended_at,   :datetime

     add_column :studies, :started_at, :datetime
     add_column :studies, :ended_at,   :datetime

  end

  def self.down
     rename_column :projects,  :started_at,:start_date
     rename_column :projects,  :ended_at,:end_date

     rename_column :tasks, :started_at,:start_date
     rename_column :tasks, :ended_at,:end_date
     
     remove_column :experiments, :started_at
     remove_column :experiments, :ended_at

     remove_column :studies, :started_at
     remove_column :studies, :ended_at
  end
end
