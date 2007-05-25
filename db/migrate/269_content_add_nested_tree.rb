class ContentAddNestedTree < ActiveRecord::Migration
  def self.up
    add_column    :project_contents,   :left_limit, :integer ,:default=>0, :null => false
    add_column    :project_contents,   :right_limit, :integer ,:default=>0,:null => false
    add_column    :project_contents,   :scope_id, :integer 
    add_column    :project_contents,   :parent_id, :integer 
  end

  def self.down
    remove_column    :project_contents,   :left_limit
    remove_column    :project_contents,   :right_limit
    remove_column    :project_contents,   :parent_id
    remove_column    :project_contents,   :scope_id
  end
end
