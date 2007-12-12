require File.dirname(__FILE__) + '/../test_helper'

class TaskTextTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :task_texts

  # Replace this with your real tests.
def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = TaskText
  end
  
  def test_truth
    assert true
  end
  
  def test_find
     first = @model.find(:first)
     assert first.id
     assert first.name
  end
  
  def test_new
    first = @model.new
    assert first
    assert first.new_record?
    assert !first.valid?
  end

  def test_update
    first = @model.find(:first)
    assert first.save
    assert !first.new_record?
    assert first.valid?
  end
  
  def test_has_value
    first = @model.find(:first)
    assert first.value   
  end

  def test_has_parameter
    first = @model.find(:first)
    assert first.parameter    
  end

  def test_has_context
    first = @model.find(:first)
    assert first.context    
  end

  def test_has_task
    first = @model.find(:first)
    assert first.task    
  end

  def test_has_task
    first = @model.find(:first)
    assert first.to_s   
  end
  
end
