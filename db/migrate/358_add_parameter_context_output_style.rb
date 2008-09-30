class AddParameterContextOutputStyle < ActiveRecord::Migration
  def self.up
    add_column :parameter_contexts,:output_style,:string,:default=>'default',:null=>false
  end

  def self.down
    remove_column :parameter_contexts,:output_style
  end
end
