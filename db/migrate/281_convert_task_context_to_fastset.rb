#
# Added left/right limits to context to allow order and resize
#
class ConvertTaskContextToFastset < ActiveRecord::Migration
  def self.up
    add_column    :task_contexts, :left_limit, :integer ,:default=>0, :null => false
    add_column    :task_contexts, :right_limit, :integer ,:default=>0,:null => false
  end

  def self.down
    remove_column    :task_contexts,   :left_limit
    remove_column    :task_contexts,   :right_limit
  end
end
