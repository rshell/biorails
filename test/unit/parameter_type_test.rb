require File.dirname(__FILE__) + '/../test_helper'

class ParameterTypeTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :parameter_types

	NEW_PARAMETER_TYPE = {:name => 'Test ParameterType', :description => 'Dummy'} #unless defined?
	REQ_ATTR_NAMES 			 = %w(name description) #unless defined? # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( name ) # unless defined?  # name of fields that cannot be a duplicate, e.g. %(name description)

  def assert_ok(object)
     assert_not_nil object, ' Object is missing'
     assert object.errors.empty? , " #{object.class}.#{object.id} has errors: "+object.errors.full_messages().join(',')
     assert object.valid?,         " #{object.class}.#{object.id} not valid: "+object.errors.full_messages().join(',')
     assert !object.new_record?,   " #{object.class}:#{object} not saved"
  end
  
  def test_find
     assert_ok ParameterType.find(:first)
  end
  
  def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = ParameterType
  end
  
  def test_parameters
    type = ParameterType.find(:first)
    list = type.parameters
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test_parameters_using_role
    type = ParameterType.find(:first)
    scope = ParameterRole.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test_parameters_using_role_live
    type = ParameterType.find(:first)
    scope = ParameterRole.find(:first)
    list = type.parameters.using(scope,true)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test_parameters_using_assay_parameter
    type = ParameterType.find(:first)
    scope = AssayParameter.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test_parameters_using_data_format
    type = ParameterType.find(:first)
    scope = DataFormat.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test_parameters_using_data_element
    type = ParameterType.find(:first)
    scope = DataElement.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test_parameters_using_data_type
    type = ParameterType.find(:first)
    scope = DataType.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test_parameters_using_parameter_context
    type = ParameterType.find(:first)
    scope = ParameterContext.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test_parameters_using_protocol_version
    type = ParameterType.find(:first)
    scope = ProtocolVersion.find(:first)
    list = type.parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test_assay_parameters_using_role
    type = ParameterType.find(:first)
    scope = ParameterRole.find(:first)
    list = type.assay_parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test_assay_parameters_using_data_format
    type = ParameterType.find(:first)
    scope = DataFormat.find(:first)
    list = type.assay_parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test_assay_parameters_using_data_element
    type = ParameterType.find(:first)
    scope = DataElement.find(:first)
    list = type.assay_parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test_assay_parameters_using_data_type
    type = ParameterType.find(:first)
    scope = DataType.find(:first)
    list = type.assay_parameters.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test_assay_parameters_using_data_type_live
    type = ParameterType.find(:first)
    scope = DataType.find(:first)
    list = type.assay_parameters.using(scope,true)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test_assay_parameters_using_string_a
    type = ParameterType.find(:first)
    scope = DataType.find(:first)
    list = type.assay_parameters.using('a',true)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test_processes_using_string_a
    type = ParameterType.find(:first)
    scope = DataType.find(:first)
    list = type.processes.using('a',true)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

   def test_processes_live
    type = ParameterType.find(:first)
    scope = DataType.find(:first)
    list = type.processes.live
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
 
  def test13_find
     first = @model.find(:first)
     assert first.id
     assert first.name
  end
  
  def test14_new
    first = @model.new
    assert first
    assert first.new_record?
    assert !first.valid?
  end

  def test15_update
    first = @model.find(:first)
    assert first.save
    assert !first.new_record?
    assert first.valid?
  end
  
 # validates_presence_of :name
 #  validates_uniqueness_of :name
  # validates_presence_of :description
 #  validates_presence_of :data_type_id
   
  def test16_has_name
    first = @model.find(:first)
    assert first.name    
  end
  
  def test_type_has_unique_name
    first = @model.find(:first)
    newtype=@model.new
    newtype.description='hello'
    newtype.name=first.name
    newtype.data_type=first.data_type
    assert !newtype.valid?
    assert newtype.errors.invalid?(:name)
  end
  
  def test_type_is_invalid_without_data_type
    first = @model.find(:first)
    newtype=@model.new
    newtype.description='hello'
    newtype.name=first.name
    assert !newtype.valid?
    assert newtype.errors.invalid?(:data_type_id)
  end
  
  def test17_has_description
    first = @model.find(:first)
    assert first.description    
  end

  def test18_test_to_xml
    type = ParameterType.find(:first)
    assert type.to_xml    
  end
  
  def test19_test_used?
    type = ParameterType.find(:first)
    assert type.used? ==!type.not_used    
  end
  
  def test20_test_style
    type = ParameterType.find(:first)
    assert type.style
  end

  def test21_test_path
    type = ParameterType.find(:first)
    assert_equal type.path, type.name
  end
  
  def test22_data_type
    type = ParameterType.find(:first)
    assert type.data_type    
  end
  
  def test_find_by_role
    list = ParameterType.find_by_role(ParameterRole.find(:first))
    assert list
    assert list.is_a?(Array)    
  end
  
  def test_scaled_units
    type = ParameterType.find(:first)
    type.storage_unit = 'mass'
    assert type.scaled_units
    type.storage_unit = nil
    assert type.scaled_units
  end
  
  def test_default_unit
    type = ParameterType.find(:first)
    type.storage_unit = 'mass'
    assert type.default_unit
    type.storage_unit = nil
    assert type.default_unit
  end
  
  def test23_from_xml
    type = ParameterType.find(:first)
    xml = type.to_xml
    assert xml
    type2 = ParameterType.from_xml(xml)
    assert type2
    assert type2.is_a?(ParameterType)
    assert_equal type2.name,type.name
  end
  
  # Ensures all the required fields have been entered
   def test_validates_presence_of
    	REQ_ATTR_NAMES.each do |attr_name|
 			tmp_parameter_type = NEW_PARAMETER_TYPE.clone
 			tmp_parameter_type.delete attr_name.to_sym
 			parameter_type = ParameterRole.new(tmp_parameter_type)
 			assert !parameter_type.valid?, "ParameterType should be invalid, as @#{attr_name} is invalid"
     	assert parameter_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
     end
    end

   #Check field validation 
   def test_raw_validation
     parameter_type = ParameterType.new
     if REQ_ATTR_NAMES.blank?
       assert parameter_type.valid?, "ParameterType should be valid without initialisation parameters"
     else
       # If ParameterType has validation, then use the following:
       assert !parameter_type.valid?, "ParameterType should not be valid without initialisation parameters"
       REQ_ATTR_NAMES.each {|attr_name| assert parameter_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
     end
   end

   # Checks to make sure there are no duplicate fields in the db, as defined in DUPLICATE_ATTR_NAMES
   def test_duplicate
     current_parameter_type = ParameterType.find(:first)
    	DUPLICATE_ATTR_NAMES.each do |attr_name|
    		parameter_type = ParameterType.new(NEW_PARAMETER_TYPE.merge(attr_name.to_sym => current_parameter_type[attr_name]))
 			assert !parameter_type.valid?, "ParameterType should be invalid, as @#{attr_name} is a duplicate"
     	assert parameter_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
 		end
 	end
 	
end

