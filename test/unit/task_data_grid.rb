require File.dirname(__FILE__) + '/../test_helper'
require 'test/unit'

class TaskBuildTest < BiorailsTestCase

  def setup
     @model = Task
     @task = @model.find(:first)
  end
  
  def test01_rows
    assert @task ,"no fixture found"
    rows = @task.rows
    assert rows, "rows is null"
    assert rows.is_a?(Hash), "expected as Hash"
    assert rows.keys.size>0,"expecting some data"
    assert rows.values[0].is_a?(TaskContext), "Should contains TaskContext objects"
    item = rows.values[0]
    assert_equal rows[item.label],item, "should be indexed by label"
  end
  
  def test02_to_grid
    grid = @task.to_grid
    assert grid, "should have a grid"
    assert_equal grid.keys.size, @task.rows.size
  end
  
  def test03_to_matrix
    matrix = @task.to_matrix
    assert matrix, "matrix should exist"
    assert_equal matrix.row_size, @task.rows.size,"number of rows not correct"
    assert_equal matrix.column_size, @task.process.names.size+1
  end
  
  def test04_row
    context = @task.contexts[0]
    assert context
    assert_equal @task.row(context.label),context," find by context label"
  end

  def test05_cell
    context = @task.contexts[0]
    item = context.definition.parameters[0]
    assert item
    assert_equal @task.row(context.label),context," find by context label"
    assert @task.cell(context.label,item.name)," find by context label+ parameter name"   
  end
  
  def test06_rows_hash
    context = @task.contexts[0]
    hash = @task.rows_indexed_by(:label) 
    assert hash, "shouldnt be nil"
    assert hash.is_a?(Hash),"No a Hash"
    assert hash[context.label] == context
  end
  
  def test07_items_grid
    context = @task.contexts[0]
    item = context.definition.parameters[0]
    grid1= @task.grid_indexed_by(:label,:name) 
    assert grid1
    assert grid1[context.label][item.name]      
  end
  
end
