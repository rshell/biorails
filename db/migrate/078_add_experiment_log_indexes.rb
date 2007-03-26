##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class AddExperimentLogIndexes < ActiveRecord::Migration
  def self.up
    add_index "experiment_logs", ["experiment_id"]
    add_index "experiment_logs", ["user_id"]
    add_index "experiment_logs", ["auditable_type","auditable_id"]
    add_index "experiment_logs", ["created_at"]
  end

  def self.down
    remove_index "experiment_logs", ["experiment_id"]
    remove_index "experiment_logs", ["user_id"]
    remove_index "experiment_logs", ["auditable_type","auditable_id"]
    remove_index "experiment_logs", ["created_at"]
  end
end
