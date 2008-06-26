class CreateCrossTabJoins < ActiveRecord::Migration
  def self.up
    create_table :cross_tab_joins do |t|
      t.integer "cross_tab_id",:null => false
      t.integer "from_parameter_context_id",  :null => false
      t.integer "to_parameter_context_id",   :null => false
      t.integer "from_parameter_id",  :null => true
      t.integer "to_parameter_id",   :null => true
      t.string "join_rule"
    end
  end

  def self.down
    drop_table :cross_tab_joins
  end
end
