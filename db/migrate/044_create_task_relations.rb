##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class CreateTaskRelations < ActiveRecord::Migration
  def self.up
    create_table :task_relations do |t|
      t.column "to_task_id", :integer
      t.column "from_task_id", :integer
      t.column "relation_id", :integer
    end
  end

  def self.down
    drop_table :task_relations
  end
end
