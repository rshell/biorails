class CreateCrossTabFilters < ActiveRecord::Migration
  def self.up
    create_table :cross_tab_filters do |t|
      t.integer "cross_tab_id", :null => false
      t.integer "parameter_id"
      t.integer "study_parameter_id", :null => false
      t.integer "parameter_type_id", :null => false
      t.string  :filter_op
      t.string  :filter_text 
      t.timestamps
    end
  end

  def self.down
    drop_table :cross_tab_filters
  end
end
