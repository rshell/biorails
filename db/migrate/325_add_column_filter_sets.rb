class AddColumnFilterSets < ActiveRecord::Migration
  def self.up
    add_column :cross_tab_filters, :session_name ,:string,:default=>'default'
    add_column :cross_tab_filters, :cross_tab_column_id ,:integer
    remove_column :cross_tab_filters, :study_parameter_id
    remove_column :cross_tab_filters, :parameter_id
    remove_column :cross_tab_filters, :parameter_type_id
  end

  def self.down
    remove_column :cross_tab_filters, :session_name
    remove_column :cross_tab_filters, :cross_tab_column_id
    add_column :cross_tab_filters, :study_parameter_id ,:integer
    add_column :cross_tab_filters, :parameter_id ,:integer
    add_column :cross_tab_filters, :parameter_type_id ,:integer
  end
end
