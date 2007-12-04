#
# Added left/right limits to context to allow order and resize
#
class ConvertParametersToFastset < ActiveRecord::Migration
  def self.up
    add_column    :parameters, :left_limit, :integer ,:default=>0, :null => false
    add_column    :parameters, :right_limit, :integer ,:default=>0,:null => false
  end

  def self.down
    remove_column    :parameters,   :left_limit
    remove_column    :parameters,   :right_limit
  end
end
