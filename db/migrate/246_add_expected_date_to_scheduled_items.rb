class AddExpectedDateToScheduledItems < ActiveRecord::Migration
  def self.up
     rename_column :projects,   :expected_date,  :expected_at
     add_column :tasks,       :expected_at, :datetime
     add_column :experiments, :expected_at, :datetime
     add_column :studies,     :expected_at, :datetime

     rename_column :queue_items,          :requested_for,:expected_at
     rename_column :reques_services,   :requested_for,:expected_at
  end

  def self.down
     remove_column :projects,    :expected_at,:expected_date
     remove_column :tasks,       :expected_date
     remove_column :experiments, :expected_date
     remove_column :studies,     :expected_date

     rename_column :queue_items,         :expected_at, :requested_for
     rename_column :request_services,  :expected_at, :requested_for
  end
end
