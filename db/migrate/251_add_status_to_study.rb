class AddStatusToStudy < ActiveRecord::Migration
  def self.up
     add_column    :studies,   :status_id, :integer
  end

  def self.down
    remove_column    :studies,   :status_id
  end
end
