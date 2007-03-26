require File.dirname(__FILE__) + '/../test_helper'

class TreeGridTest < Test::Unit::TestCase


  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_create
     task = Task.find(1)
     grid = TreeGrid.from_process(task.process)  
     puts grid.to_text("\t","\n")
  end
end
