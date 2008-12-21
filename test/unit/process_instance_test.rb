
require File.dirname(__FILE__) + '/../test_helper'

class ProcessInstanceTest < Test::Unit::TestCase
  # Replace this with your real tests.
    def setup
     @model = ProcessInstance
  end

  def test_from_xml
    item1 = ProcessInstance.find(:first)
    item2 = ProcessInstance.from_xml(item1.to_xml)  
    assert_equal item1,item2
  end
    
  def test01_parameters
    type = ProcessInstance.find(:first)
    list = type.parameters
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test02_parameters_using_role
    type = ProcessInstance.find(:first)
    scope = ParameterRole.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test03_parameters_using_assay_parameter
    type = ProcessInstance.find(:first)
    scope = AssayParameter.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test04_parameters_using_data_format
    type = ProcessInstance.find(:first)
    scope = DataFormat.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test05_parameters_using_data_element
    type = ProcessInstance.find(:first)
    scope = DataElement.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test06_parameters_using_data_type
    type = ProcessInstance.find(:first)
    scope = DataType.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test07_parameters_using_parameter_context
    type = ProcessInstance.find(:first)
    scope = ParameterContext.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test08_parameters_using_protocol_version
    type = ProcessInstance.find(:first)
    scope = AssayQueue.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
    
  def test09_find
     first = @model.find(:first)
     assert first.id
     assert first.name
  end
  
  def test10_definition
    first = @model.find(:first)
    assert_equal 'Protocol1', first.definition.name
  end
  
  def test11_new
    first = @model.new
    assert first
    assert first.new_record?
    assert !first.valid?
  end

  def test12_update
    first = @model.find(:first)
    assert first.save
    assert !first.new_record?
    assert first.valid?
  end
  
  def test13_has_path
    first = @model.find(:first)
    assert first.path    
  end
  
  def test14_has_name
    first = @model.find(:first)
    assert first.name    
  end

  def test15_is_used
    first = @model.find(:first)
    first.used?  == (Task.count(:conditions=>['protocol_version_id=?',first.id])==0)      
  end
  
  def test16_flexible?
    first = @model.find(:first)
    assert first.flexible? == (Task.count(:conditions=>['protocol_version_id=?',first.id])<2)
  end

  def test17_names
    first = @model.find(:first)
    assert first.names.size == first.parameters.size  
  end

  def test18_styles
    first = @model.find(:first)
    assert first.styles.size == first.parameters.size    
  end

  def test19_resync_columns  
    first = @model.find(:first)
    count = first.parameters.size
    first.resync_columns   
    assert first.parameters.size == count    
  end
  
  def test20_has_parameters
    first = @model.find(:first)
    assert first.parameters   
    assert first.parameters.size>0   
  end

  def test21_has_contexts
    first = @model.find(:first)
    assert first.contexts  
    assert first.contexts.size>0  
  end  

  def test22_has_protocol
    first = @model.find(:first)
    assert !first.protocol.nil?   
  end  

  def test23_has_roots
    first = @model.find(:first)
    assert first.roots   
  end  

  def test24_has_stats
    first = @model.find(:first)
    assert first.stats   
  end  

  def test25_has_tasks  
    first = @model.find(:first)
    assert first.tasks  
  end  
  
  def test26_copy_process
    first = @model.find(:first)
    other = first.copy
    assert other.id !=first.id
    assert other.parameters.count == first.parameters.count, "parameters collection not same"
    assert other.contexts.count ==first.contexts.count, "contexts collection not same"
    assert other.roots.count ==first.roots.count, "roots collection not same"
  end  
  
  def test27_context
    first = @model.find(:first)
    assert first.context(first.first_context) == first.first_context    
    assert first.context(first.first_context.label) == first.first_context    
    assert first.context(first.first_context.id) == first.first_context      
  end

  def test28_to_xml
    first = @model.find(:first)
    assert first.to_xml
  end
  
  def test29_parameter
    first = @model.find(:first)
    param = first.parameters[0]
    assert_equal param,first.parameter(param)
    assert_equal param,first.parameter(param.id)
    assert_equal param,first.parameter(param.name)
  end   
  
  def test30_role_parameters
    first = @model.find(:first)
    param = first.parameters[0]
    assert first.role_parameters( param.role )
    assert_equal first.parameters, first.role_parameters
  end

  def test31_not_multistep
    first = @model.find(:first)
    assert !first.multistep?
  end

  def test32_usages_count
    first = @model.find(:first)
    assert first.usage_count
  end
  
  def test33_max_columns
    first = @model.find(:first)
    assert first.max_columns
  end

  def test34_reformat
    first = @model.find(:first)
    assert first.reformat({})
  end

end
