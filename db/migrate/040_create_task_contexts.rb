##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class CreateTaskContexts < ActiveRecord::Migration
  def self.up
    create_table :task_contexts do |t|
      t.column "task_id", :integer
      t.column "parameter_context_id", :integer
      t.column "label", :string
      t.column "is_valid", :boolean
    end
  end

  def self.down
    drop_table :task_contexts
  end
end
