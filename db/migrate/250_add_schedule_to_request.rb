class AddScheduleToRequest < ActiveRecord::Migration
  def self.up
     rename_column :requests,   :requested_for,  :expected_at
     add_column    :requests,   :started_at, :datetime
     add_column    :requests,   :ended_at, :datetime
  end

  def self.down
     rename_column    :requests,   :expected_at,  :requested_for
     remove_column    :requests,   :started_at, :datetime
     remove_column    :requests,   :ended_at, :datetime
  end
end
