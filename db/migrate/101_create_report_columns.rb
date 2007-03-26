##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class CreateReportColumns < ActiveRecord::Migration
  def self.up
    create_table :report_columns do |t|
      t.column "report_id", :integer, :null => false
      t.column "name", :string, :limit => 128, :default => "", :null => false
      t.column "description", :text      
      t.column "join_model", :string      
      t.column "label", :string      
      t.column "action", :text
      t.column "filter_operation", :string   
      t.column "filter_text", :string   
      t.column "subject_type", :string
      t.column "subject_id", :integer
      t.column "data_element", :integer
      t.column "is_visible", :boolean, :default => true, :null => false
      t.column "is_filterible", :boolean, :default => true, :null => false
      t.column "is_sortable", :boolean, :default => true, :null => false
      t.column "order_num", :integer
      t.column "sort_num", :integer
      t.column "sort_direction", :string
      t.column "lock_version", :integer, :default => 0, :null => false
      t.column "created_by", :string, :limit => 32, :default => "", :null => false
      t.column "created_at", :datetime, :null => false
      t.column "updated_by", :string, :limit => 32, :default => "", :null => false
      t.column "updated_at", :datetime, :null => false
    end
  end

  def self.down
    drop_table :report_columns
  end
end
