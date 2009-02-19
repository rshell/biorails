require File.dirname(__FILE__) + '/../test_helper'

class ParameterContextTest < BiorailsTestCase
  # Replace this with your real tests.
    def setup
     @model = ParameterContext
  end
  
  def test_find
     first = @model.find(:first)
     assert first.id
     assert first.label
     assert first.name
     assert first.count_string
  end

  def test_from_xml
    item1 = ParameterContext.find(:first)
    item2 = ParameterContext.from_xml(item1.to_xml)  
    assert_equal item1,item2
  end
  
  def test_parameters
    type = ParameterContext.find(:first)
    list = type.parameters
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test_parameters_using_role
    type = ParameterContext.find(:first)
    scope = ParameterRole.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test_parameters_using_role_live
    type = ParameterContext.find(:first)
    scope = ParameterRole.find(:first)
    list = type.parameters.using(scope,true)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test_parameters_using_text
    type = ParameterContext.find(:first)
    scope = ParameterRole.find(:first)
    list = type.parameters.using('a',true)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test_parameters_using_assay_parameter
    type = ParameterContext.find(:first)
    scope = AssayParameter.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test_parameters_using_data_format
    type = ParameterContext.find(:first)
    scope = DataFormat.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test_parameters_using_data_element
    type = ParameterContext.find(:first)
    scope = DataElement.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test_parameters_using_data_type
    type = ParameterContext.find(:first)
    scope = DataType.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test_parameters_using_protocol_version
    type = ParameterContext.find(:first)
    scope = AssayQueue.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
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
  
  def test_has_label
    first = @model.find(:first)
    assert first.label    
  end
  
  def test_has_default_count
    first = @model.find(:first)
    assert first.default_count    
  end
  
  def test_has_parameters
    first = @model.find(:first)
    assert first.parameters   
    assert first.parameters.size>0   
  end

  def test_has_process
    first = @model.find(:first)
    assert first.process    
  end  

  def test_new_queue
    first = @model.find(:first)
    assert_equal 0, first.queues.size 
    assert !first.queue? 
  end  

  def test_new_queue
    queue = AssayQueue.find(1)
    context = ParameterContext.find(1)
    param = context.add_queue(queue)
    assert_ok param
  end  

  def test_parameter
    assert task_value = TaskValue.find(:first)
    assert parameter = task_value.parameter
    assert context = task_value.context.definition
    assert_equal parameter,context.parameter(parameter)    
    assert_equal parameter,context.parameter(task_value)    
    assert_equal parameter,context.parameter(task_value.parameter_id)    
    assert_equal parameter,context.parameter(task_value.parameter.name)    
  end  

  def test_is_related
    first = @model.find(:first,:conditions=>'parent_id is not null')
    assert first.is_related(first)
    assert first.parent
    assert first.is_related(first.parent)    
  end
  
  def test_to_xml
    first = @model.find(:first,:conditions=>'parent_id is not null')
    assert first.to_xml
  end
 
  def test_build_empty_row
    first = @model.find(:first,:conditions=>'parent_id is not null')
    values = first.default_row    
    assert values.size == first.parameters.size    
  end

    def test_default_total_greater_then_zero
    first = @model.find(:first,:conditions=>'parent_id is not null')
    assert first.default_total > 0    
  end

  def test_default_total_greater_then_zero
    first = @model.find(:first,:conditions=>'parent_id is null')
    assert first.default_total > 0    
    assert first.default_total == first.default_count  
  end

  def test_build_empty_block
    first = @model.find(:first,:conditions=>'parent_id is not null')
    block = first.default_block 
    assert block
    assert block.size >0
    assert block.values[0].size > 0
    assert block.values.size == first.default_count    
    assert block.values[0].size == first.parameters.size    
  end
  
  def test_build_default_row_labels
    first = @model.find(:first,:conditions=>'parent_id is not null')
    assert first.label
    labels = first.default_labels
    assert labels 
    assert labels.size > 0 
    assert labels.size == first.default_total   
    assert labels.all?{|i|i.size>0}    
  end
end
