#
# Changing to a neated set for elements for better management
#
#
class ProjectElementToNeatedSet < ActiveRecord::Migration
  def self.up
    add_column    :project_elements,   :left_limit, :integer ,:default=>0, :null => false
    add_column    :project_elements,   :right_limit, :integer ,:default=>0,:null => false
  end

  def self.down
    remove_column    :project_elements,   :left_limit
    remove_column    :project_elements,   :right_limit
  end
end
