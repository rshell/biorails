class AddDefaultStateToObjects < ActiveRecord::Migration
  def self.up
    change_column_default(:project_elements, :state_id, State.find(:first).id)
  end

  def self.down
  end
end
