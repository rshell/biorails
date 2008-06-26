require File.dirname(__FILE__) + '/../test_helper'

class AssayParameterTest < Test::Unit::TestCase


def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = AssayParameter
  end
  
  def test_truth
    assert true
  end
  
  def test_find
     first = @model.find(:first)
     assert first.id
     assert first.name
     assert first.full_name
  end
  
  def test_new
    first = @model.new
    assert first
    assert first.new_record?
    assert !first.valid?
    assert first.units
  end

  def test_all_ok
    list = @model.find(:all)
    for item in list
      assert item.valid?
      assert item.full_name
      assert item.name
      assert item.units
    end
  end

  def test_update
    first = @model.find(:first)
    assert first.save
    assert !first.new_record?
    assert first.valid?
  end
  
  def test_has_name
    first = @model.find(:first)
    assert first.name    
  end

  def test_has_description
    first = @model.find(:first)
    assert first.description    
  end

  def test_belongs_to_assay
    first = @model.find(:first)
    assert first.assay    
  end

  def test_belongs_to_parameter_type
    first = @model.find(:first)
    assert first.type    
  end

  def test_belongs_to_parameter_role
    first = @model.find(:first)
    assert first.role
  end

  def test_belongs_to_parameter_type
    first = @model.find(:first)
    assert first.type    
  end

  def test_usages
    first = @model.find(:first)
    assert first.parameters
    assert first.usages
    assert_equal first.parameters,first.usages
  end

  def test_contexts
    first = @model.find(:first)
    assert first.contexts 
  end

  def test_processes
    first = @model.find(:first)
    assert first.processes 
  end

  def test_path
    first = @model.find(:first)
    assert first.path
  end

  def test14_path
    first = @model.find(:first)
    assert first.path
    assert first.path(:xxxx)    
  end

  def test_path_project
    first = @model.find(:first)
    assert first.path(:world)
    assert first.path(:project)
  end

  def test_path_assay
    first = @model.find(:first)
    assert first.path(:root)
    assert first.path(:parameters)
    assert first.path(:assay)
  end

  def test_units
    first = @model.find(:first)
    assert first.units
  end

  def test_mask
    first = @model.find(:first)
    assert first.mask
  end

  def test_parse_date
    item = AssayParameter.find(:first,:conditions=>['data_type_id=?',Biorails::Type::DATE])
    if item
      date = item.parse("1999-12-23")
      assert date
    end
  end
  
  def test_parse_numeric
    item = AssayParameter.find(:first,:conditions=>['data_type_id=?',Biorails::Type::NUMERIC])
    if item
      num = item.parse("10")
      assert_equal num,"10 mM"
    end
  end

  def test_parse_text
    item = AssayParameter.find(:first,:conditions=>['data_type_id=?',Biorails::Type::TEXT])
    if item
      num = item.parse("10")
      assert_equal num,"10"
    end
  end

    def test_find_parameters_using
     first = @model.find(:first)
     scope = ParameterType.find(:first)
     list = first.parameters.using(nil,true)
     assert list
     assert list.is_a?(Array)
  end

    def test_find_contexts_using
     first = @model.find(:first)
     scope = ParameterType.find(:first)
     list = first.contexts.using(nil,true)
     assert list
     assert list.is_a?(Array)
  end

  def test_find_parameters_using_type
     first = @model.find(:first)
     scope = ParameterType.find(:first)
     list = first.parameters.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_parameters_using_role
     first = @model.find(:first)
     scope = ParameterRole.find(:first)
     list = first.parameters.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_parameters_using_format
     first = @model.find(:first)
     scope = DataFormat.find(:first)
     list = first.parameters.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_parameters_using_data_type
     first = @model.find(:first)
     scope = DataType.find(:first)
     list = first.parameters.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_parameters_using_element
     first = @model.find(:first)
     scope = DataElement.find(:first)
     list = first.parameters.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_parameters_using_queue
     first = @model.find(:first)
     scope = AssayQueue.find(:first)
     list = first.parameters.using(scope)
     assert list
     assert list.is_a?(Array)
  end

  def test_find_parameters_using_type_in_use
     first = @model.find(:first)
     scope = ParameterType.find(:first,true)
     list = first.parameters.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_parameters_using_role_in_use
     first = @model.find(:first)
     scope = ParameterRole.find(:first)
     list = first.parameters.using(scope,true)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_parameters_using_format_in_use
     first = @model.find(:first)
     scope = DataFormat.find(:first,true)
     list = first.parameters.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_parameters_using_data_type_in_use
     first = @model.find(:first)
     scope = DataType.find(:first,true)
     list = first.parameters.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_parameters_using_element_in_use
     first = @model.find(:first)
     scope = DataElement.find(:first,true)
     list = first.parameters.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_parameters_using_queue_in_use
     first = @model.find(:first)
     scope = AssayQueue.find(:first,true)
     list = first.parameters.using(scope)
     assert list
     assert list.is_a?(Array)
  end

  def test_find_contexts_using_type
     first = @model.find(:first)
     scope = ParameterType.find(:first)
     list = first.contexts.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_contexts_contexts_using_role
     first = @model.find(:first)
     scope = ParameterRole.find(:first)
     list = first.contexts.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_contexts_using_format
     first = @model.find(:first)
     scope = DataFormat.find(:first)
     list = first.contexts.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_contexts_using_data_type
     first = @model.find(:first)
     scope = DataType.find(:first)
     list = first.parameters.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_contexts_using_element
     first = @model.find(:first)
     scope = DataElement.find(:first)
     list = first.contexts.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_contexts_using_queue
     first = @model.find(:first)
     scope = AssayQueue.find(:first)
     list = first.contexts.using(scope)
     assert list
     assert list.is_a?(Array)
  end

  def test_find_contexts_using_type_in_use
     first = @model.find(:first)
     scope = ParameterType.find(:first)
     list = first.contexts.using(scope,true)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_contexts_using_role_in_use
     first = @model.find(:first)
     scope = ParameterRole.find(:first)
     list = first.contexts.using(scope,true)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_contexts_using_format_in_use
     first = @model.find(:first)
     scope = DataFormat.find(:first)
     list = first.contexts.using(scope,true)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_contexts_using_data_type_in_use
     first = @model.find(:first)
     scope = DataType.find(:first)
     list = first.parameters.using(scope,true)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_contexts_using_element_in_use
     first = @model.find(:first)
     scope = DataElement.find(:first)
     list = first.contexts.using(scope,true)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_contexts_using_queue_in_use
     first = @model.find(:first)
     scope = AssayQueue.find(:first)
     list = first.contexts.using(scope,true)
     assert list
     assert list.is_a?(Array)
  end
  

    def test_find_contexts_using
     first = @model.find(:first)
     scope = ParameterType.find(:first)
     list = first.contexts.using(nil,true)
     assert list
     assert list.is_a?(Array)
  end

  def test_find_processes_using_type
     first = @model.find(:first)
     scope = ParameterType.find(:first)
     list = first.processes.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_processes_using_role
     first = @model.find(:first)
     scope = ParameterRole.find(:first)
     list = first.processes.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_processes_using_format
     first = @model.find(:first)
     scope = DataFormat.find(:first)
     list = first.processes.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_processes_using_data_type
     first = @model.find(:first)
     scope = DataType.find(:first)
     list = first.processes.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_processes_using_element
     first = @model.find(:first)
     scope = DataElement.find(:first)
     list = first.processes.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_processes_using_queue
     first = @model.find(:first)
     scope = AssayQueue.find(:first)
     list = first.processes.using(scope)
     assert list
     assert list.is_a?(Array)
  end

  def test_find_processes_using_type_in_use
     first = @model.find(:first)
     scope = ParameterType.find(:first,true)
     list = first.processes.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_processes_using_role_in_use
     first = @model.find(:first)
     scope = ParameterRole.find(:first)
     list = first.processes.using(scope,true)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_processes_using_format_in_use
     first = @model.find(:first)
     scope = DataFormat.find(:first,true)
     list = first.processes.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_processes_using_data_type_in_use
     first = @model.find(:first)
     scope = DataType.find(:first,true)
     list = first.processes.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_processes_using_element_in_use
     first = @model.find(:first)
     scope = DataElement.find(:first,true)
     list = first.processes.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
  def test_find_processes_using_queue_in_use
     first = @model.find(:first)
     scope = AssayQueue.find(:first,true)
     list = first.processes.using(scope)
     assert list
     assert list.is_a?(Array)
  end
  
end

