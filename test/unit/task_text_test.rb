require File.dirname(__FILE__) + '/../test_helper'

class TaskTextTest < BiorailsTestCase
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

  def test_to_unit
    first = @model.find(:first)
    first.value= "xxx"
    assert_equal nil, first.to_unit
  end

  def test_default_value
    first = @model.find(:first)
    first.parameter.default_value = 'x'
    first.data_content = nil
    assert_equal 'x', first.to_s
  end

  def test_set_value
    item = @model.find(:first)
    item.value ="t"
    assert_equal "t",item.data_content
    assert_equal "t",item.value
    assert_equal "t",item.to_s
  end
  
  
end
