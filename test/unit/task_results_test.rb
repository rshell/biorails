require File.dirname(__FILE__) + '/../test_helper'

class TaskResultsTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :task_files

  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_queue_result
    result = QueueResult.find(:first)
    assert_nil result, "New QueueResult found Fixtures for TaskValue"
  end

  def test_properties_queue_result
    result = QueueResult.new(
       :parameter_id => Parameter.find(:first).id,
       :parameter_context_id => ParameterContext.find(:first).id,
       :data_value => 12.22)
    assert_ok result.parameter
    assert result.value
    assert_ok result.definition
    assert result.value
    assert_raise(ActiveRecord::ReadOnlyRecord){ result.save }
  end

  def test_task_result
    result =TaskResult.find(:first)
    assert_ok result.parameter
    assert_ok result.process
    assert_ok result.definition
    assert result.name
    assert result.value
  end
  
  
end
