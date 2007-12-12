require File.dirname(__FILE__) + '/../test_helper'

class TreeGridTest < Test::Unit::TestCase

  # Replace this with your real tests.
  def test_truth
    assert true
 end
    #
  # See if data items and hashes contains corrent number of columns
  #
  def test_get_grid()
    task =Task.find(:first)
    grid = task.grid
    assert grid
    assert grid.task == task
    assert  grid.id == task.id
    assert grid.rows.size >0 
    assert grid.to_s
    assert grid.rows[0].cells[0]
  end
  
  def test_grid_row_has_definition
    task =Task.find(:first)
    grid =task.grid
    assert grid
    assert grid.rows[0].definition
  end

  def test_grid_row_has_label
    task =Task.find(:first)
    grid =task.grid
    assert grid
    assert grid.rows[0].label
  end

  def test_grid_row_has_cells
    task =Task.find(:first)
    grid =task.grid
    assert grid
    assert grid.rows[0].cells
  end

  def test_grid_row_has_task
    task =Task.find(:first)
    grid =task.grid
    assert grid
    assert grid.rows[0].task == task
  end

  def test_grid_row_has_dom_id
    task =Task.find(:first)
    grid =task.grid
    assert grid
    assert grid.rows[0].task == task
  end

  def test_grid_row_has_path
    task =Task.find(:first)
    grid =task.grid
    assert grid
    assert grid.rows[0].path
  end
  
  def test_grid_row_has_names
    task =Task.find(:first)
    grid =task.grid
    assert grid
    assert grid.rows[0].names
  end

  def test_grid_row_has_styles
    task =Task.find(:first)
    grid =task.grid
    assert grid
    assert grid.rows[0].styles
  end

  def test_grid_row_has_values
    task =Task.find(:first)
    grid =task.grid
    assert grid
    assert grid.rows[0].styles
  end
 

 def test_grid_cell_has_parameter
    task =Task.find(:first)
    grid =task.grid
    assert grid
    assert grid.rows[0].cells[0].parameter
  end

  def test_grid_cell_has_dom_id
    task =Task.find(:first)
    grid =task.grid
    assert grid
    assert grid.rows[0].cells[0].dom_id
  end

  
  def test_grid_cell_has_task
    task =Task.find(:first)
    grid =task.grid
    assert grid
    assert grid.rows[0].cells[0].task == task
  end

  def test_grid_cell_has_mask
    task =Task.find(:first)
    grid =task.grid
    assert grid
    assert grid.rows[0].cells[0].mask
  end

  def test_grid_cell_to_html
    task =Task.find(:first)
    grid =task.grid
    assert grid
    assert grid.rows[0].cells[0].to_html
  end

  def test_grid_cell_to_s
    task =Task.find(:first)
    grid =task.grid
    assert grid
    assert grid.rows[0].cells[0].to_s
  end  
  
end
