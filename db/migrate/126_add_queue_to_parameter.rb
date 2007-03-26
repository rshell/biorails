##
# Adding links between work queue a parameter in a process
#
class AddQueueToParameter < ActiveRecord::Migration
  def self.up
      add_column :parameters, :study_queue_id, :integer   
  end

  def self.down
      remove_column :parameters, :study_queue_id  
  end
end
