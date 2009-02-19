require File.dirname(__FILE__) + '/../test_helper'


class ProcessFlowTest <  BiorailsTestCase
  
  # Replace this with your real tests.
  def setup
     @model = ProcessFlow
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
  
  def test_has_path
    first = @model.find(:first)
    assert first.path    
  end

  def test_first_step_begins_hour 
    first = @model.find(:first)
    assert first.first_step_begins_hour  
  end
  
  def test_expected_weeks
    first = @model.find(:first)
    assert first.expected_weeks
  end
  
  def test_expected_days
    first = @model.find(:first)
    assert first.expected_days
    
    assert first.expected_days
  end
  
  def test_use_as_process
    first = @model.find(:first)
    assert_equal [],first.contexts
    assert_equal [],first.parameters
  end
  
  def test_has_name
    first = @model.find(:first)
    assert first.name    
  end

  def test_has_protocol
    first = @model.find(:first)
    assert !first.protocol.nil?   
  end  

  def test_to_xml
    first = @model.find(:first)
    assert first.to_xml
  end

  def test_from_xml
    item1 = ProcessFlow.find(:first)
    item2 = ProcessFlow.from_xml(item1.to_xml)  
    assert_equal item1,item2
  end
    
  
end
