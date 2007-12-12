require File.dirname(__FILE__) + '/../test_helper'

class TaskContextTest < Test::Unit::TestCase
  
  TASK_ID = 1
  
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  
  def test_find
    task = Task.find(TASK_ID)
    assert task.contexts.count > 0
  end
  
  #
  # See if data items and hashes contains corrent number of columns
  #
  def test_get_grid
    task = Task.find(TASK_ID)
    task.process.contexts.each  do |definition| 
      rows = task.contexts.matching(definition)
      rows.each do |row|
        assert row.to_hash
        assert row.items
        assert row.items.size = row.to_hash.size
        assert row.items.size = definition.parameters.size
      end
    end    
  end
  
  
end
