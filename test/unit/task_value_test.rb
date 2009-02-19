require File.dirname(__FILE__) + '/../test_helper'

class TaskValueTest < BiorailsTestCase

  def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = TaskValue
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
    assert first.to_s.is_a?(String)
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

  def test_to_unit
    first = @model.find(:first)
    assert first.to_unit
  end

  def test_default_value
    first = @model.find(:first)
    first.parameter.default_value = 10.0
    first.data_value = nil
    assert_equal '10.0', first.to_s
  end

  def test_set_value_unitless
    item = @model.find(:first)
    item.parameter.display_unit = nil
    item.value ="10"
    assert_equal 10.0,item.data_value
    assert_equal 10.0,item.value
    assert_equal "10",item.to_s
  end  

  def test_set_value_unit
    item = @model.find(:first)
    item.parameter.display_unit = nil
    item.value ="10 mm"
    assert_equal 0.01,item.data_value
    assert_equal "m",item.storage_unit
    assert_equal "mm",item.display_unit
    assert_equal "10 mm".to_unit,item.to_unit
    assert_equal "10 mm",item.to_s
  end  

  def test_set_value_unit_and_default
    item = @model.find(:first)
    item.parameter.display_unit = "mm"
    item.value ="10 mm"
    assert_equal 0.01,item.data_value
    assert_equal "m",item.storage_unit
    assert_equal "mm",item.display_unit
    assert_equal "10 mm".to_unit,item.to_unit
    assert_equal "10",item.to_s
  end  
  
end
