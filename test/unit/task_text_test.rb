require File.dirname(__FILE__) + '/../test_helper'

class TaskTextTest < Test::Unit::TestCase
  fixtures :task_texts

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test001_schedule
     assert_not_null Task.schedule_states
     assert_not_null Task.schedule_state_changes
     assert_not_null Task.schedule_state_active
     assert_not_null Task.schedule_state_finished
     assert_not_null Task.schedule_state_failed
     assert_not_null Task.schedule_started
     assert_not_null Task.schedule_ended
     assert_not_null Task.schedule_expected
     assert_not_null Task.schedule_status_id
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
