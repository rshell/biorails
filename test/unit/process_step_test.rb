require File.dirname(__FILE__) + '/../test_helper'

class ProcessStepTest < Test::Unit::TestCase

  def setup
    @step=ProcessStep.find(1)
    @flow = @step.flow
    @process = @step.process
  end
  
  def test_setup
   assert_not_nil @step
   assert_not_nil @flow
   assert_not_nil @process
   assert @step.is_a?(ProcessStep), 'ProcessStep is invalid in fixtures'
   assert @flow.is_a?(ProcessFlow), 'ProcessStep.flow is invalid in fixtures'
   assert @process.is_a?(ProcessInstance), 'ProcessStep.process is invalid in fixtures'
  end

  def test_resync_end_times
    assert_equal 11.0, @step.resync_end_times
  end
  
  def test_step_period
    assert_equal 1, @step.period
  end
  
  def test_starting
    assert_equal 10,@step.starting
  end

  def test_remaining
    assert_equal 13,@step.remaining
  end

  def test_period
    assert_equal 1,@step.period
  end

  def test_period
    assert_equal [],@step.dependents
  end
  
  def test_requirements
    assert_equal [],@step.requirements
  end
  
  def test_process
    assert_equal ProcessInstance.find(3), @step.process
  end

  def test_flow
    assert_equal ProcessFlow.find(10), @step.flow
  end


  def test_copy_process_step
    @other = ProcessStep.copy(@step)
    assert_equal  @step.start_offset_hours ,@other.start_offset_hours
    assert_equal  @step.end_offset_hours ,@other.end_offset_hours
    assert_equal  @step.expected_hours ,@other.expected_hours
    assert_not_equal  @step.name ,@other.name
  end

  def test_copy_task
    @task = Task.find(:first)
    @other = ProcessStep.copy(@task)
    assert_equal      @other.start_offset_hours , @task.started_at - @task.experiment.started_at
    assert_equal      @other.expected_hours ,@task.expected_hours
    assert_not_equal  @other.name ,@task.name
  end
  
end
