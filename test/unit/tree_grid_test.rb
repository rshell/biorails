require File.dirname(__FILE__) + '/../test_helper'

class TreeGridTest < Test::Unit::TestCase
  fixtures :projects
  fixtures :studies
  fixtures :study_protocols
  fixtures :study_parameters
  fixtures :protocol_versions
  fixtures :parameters
  fixtures :experiments
  fixtures :experiments
  fixtures :tasks
  fixtures :task_contexts
  fixtures :task_values
  fixtures :task_texts
 

  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_create
     process = ProtocolVersion.find(:first)
     assert_not_nil process

     grid = TreeGrid.from_process(process)  
     assert_not_nil grid.to_csv
  end


  def test_create
     task = Task.find( :first )
     assert_not_nil task
     
     assert_not_nil task.grid
     assert_not_nil task.to_csv
  end

end
