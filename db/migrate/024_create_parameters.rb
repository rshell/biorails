##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##

class CreateParameters < ActiveRecord::Migration
  def self.up
  create_table "parameters", :force => true do |t|
    t.column "process_instance_id", :integer
    t.column "parameter_context_id", :integer
    t.column "parameter_type_id", :integer
    t.column "parameter_role_id", :integer
    t.column "column_no", :integer
    t.column "sequence_num", :integer
    t.column "name", :string, :limit => 62
    t.column "description", :string, :limit => 62
    t.column "display_unit", :string, :limit => 20
    t.column "data_element_id", :string, :limit => 1
    t.column "qualifier_style", :string, :limit => 1
    t.column "access_control_id", :integer, :default => 0, :null => false
    t.column "lock_version", :integer, :default => 0, :null => false
    t.column "created_by", :string, :limit => 32, :default => "", :null => false
    t.column "created_at", :datetime, :null => false
    t.column "updated_by", :string, :limit => 32, :default => "", :null => false
    t.column "updated_at", :datetime, :null => false
  end
  end

  def self.down
    drop_table :parameters
  end
end
