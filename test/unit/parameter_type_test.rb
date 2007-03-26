require File.dirname(__FILE__) + '/../test_helper'

class ParameterTypeTest < Test::Unit::TestCase
  fixtures :parameter_types

	NEW_PARAMETER_TYPE = {:name => 'Test ParameterType', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w(name description) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( name ) # name of fields that cannot be a duplicate, e.g. %(name description)

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

	def test_new
      parameter_type = ParameterType.new(NEW_PARAMETER_TYPE)
      assert parameter_type.valid?, "ParameterType should be valid"
     	NEW_PARAMETER_TYPE.each do |attr_name|
        assert_equal NEW_PARAMETER_TYPE[attr_name], parameter_type.attributes[attr_name], "ParameterType.@#{attr_name.to_s} incorrect"
      end
 	end

	def test_validates_presence_of
     	REQ_ATTR_NAMES.each do |attr_name|
  			tmp_parameter_type = NEW_PARAMETER_TYPE.clone
  			tmp_parameter_type.delete attr_name.to_sym
  			parameter_type = ParameterType.new(tmp_parameter_type)
  			assert !parameter_type.valid?, "ParameterType should be invalid, as @#{attr_name} is invalid"
      	assert parameter_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
      end
 	end

	def test_duplicate
    current_parameter_type = ParameterType.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		parameter_type = ParameterType.new(NEW_PARAMETER_TYPE.merge(attr_name.to_sym => current_parameter_type[attr_name]))
			assert !parameter_type.valid?, "ParameterType should be invalid, as @#{attr_name} is a duplicate"
    	assert parameter_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
	
	def test_create
	   parameter_type = ParameterType.new(NEW_PARAMETER_TYPE)
	   assert parameter_type.save
       #assert parameter_type.reload?
    end
    
    def test_bad_save
       parameter_type = ParameterType.new
       parameter_type.name = nil
       parameter_type.description = "A Description"
       assert !parameter_type.save
    end

end

