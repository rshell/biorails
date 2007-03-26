##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class AddStudyLogIndexes < ActiveRecord::Migration
  def self.up
    add_index "study_logs", ["study_id"]
    add_index "study_logs", ["user_id"]
    add_index "study_logs", ["auditable_type","auditable_id"]
    add_index "study_logs", ["created_at"]
  end

  def self.down
    remove_index "study_logs", ["study_id"]
    remove_index "study_logs", ["user_id"]
    remove_index "study_logs", ["auditable_type","auditable_id"]
    remove_index "study_logs", ["created_at"]
  end
end
