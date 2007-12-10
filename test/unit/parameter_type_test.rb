require File.dirname(__FILE__) + '/../test_helper'

class ParameterTypeTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :parameter_types

	NEW_PARAMETER_TYPE = {:name => 'Test ParameterType', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w(name description) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( name ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def assert_ok(object)
     assert_not_nil object, ' Object is missing'
     assert object.errors.empty? , " #{object.class}.#{object.id} has errors: "+object.errors.full_messages().join(',')
     assert object.valid?,         " #{object.class}.#{object.id} not valid: "+object.errors.full_messages().join(',')
     assert !object.new_record?,   " #{object.class}:#{object} not saved"
  end
  
  def test_find
     assert_ok ParameterType.find(:first)
  end
  
end

