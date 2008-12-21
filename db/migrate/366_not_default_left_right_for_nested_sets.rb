class NotDefaultLeftRightForNestedSets < ActiveRecord::Migration
  def self.up
    change_column_default(:project_elements, :left_limit, nil)
    change_column_default(:project_elements, :right_limit,nil)
    change_column_default(:parameter_contexts, :left_limit, nil)
    change_column_default(:parameter_contexts, :right_limit,nil)
    change_column_default(:task_contexts, :left_limit, nil)
    change_column_default(:task_contexts, :right_limit,nil)
  end

  def self.down
    change_column_default(:project_elements, :left_limit, 1)
    change_column_default(:project_elements, :right_limit,2)
    change_column_default(:parameter_contexts, :left_limit, 1)
    change_column_default(:parameter_contexts, :right_limit,2)
    change_column_default(:task_contexts, :left_limit, 1)
    change_column_default(:task_contexts, :right_limit,2)
  end
end
