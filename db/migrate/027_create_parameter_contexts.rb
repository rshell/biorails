##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

class CreateParameterContexts < ActiveRecord::Migration
  def self.up
    create_table :parameter_contexts do |t|
        t.column "process_instance_id", :integer
        t.column "parent_id", :integer
        t.column "level_no", :integer
        t.column "label", :string
        t.column "default_count", :integer
    end
  end

  def self.down
    drop_table :parameter_contexts
  end
end
