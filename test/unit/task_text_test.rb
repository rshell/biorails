require File.dirname(__FILE__) + '/../test_helper'

class TaskTextTest < Test::Unit::TestCase
  fixtures :task_texts

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  

  
  def test002_schedule
     task = Task.find(:first)
     task.started_at
     task.expected_at
     task.ended_at
     task.status
     task.status_id
  end
end
