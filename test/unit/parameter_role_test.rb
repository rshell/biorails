require File.dirname(__FILE__) + '/../test_helper'

class ParameterRoleTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :parameter_roles

  NEW_PARAMETER_ROLE = {:name => 'Test Parameter Role', 
                        :description => 'Dummy Descripton',
                        :weighing => '0'}
  REQ_ATTR_NAMES  = %w(name description) # name of fields that must be present, e.g. %(name description)
  DUPLICATE_ATTR_NAMES = %w( name ) # name of fields that cannot be a duplicate, e.g. %(name description)
  LONG_NAMED_PARAMETER_ROLE = {:name => '123 456 789 123 456 789 123 456 789 123 456 789 123 456 789', 
                               :description => 'Dummy Descripton',
                               :weighing => '0'}
  MAX_NAME = "123 456 789 123 456 789 123 456 789 123 456 789 12"
  
 
  # Create a new role and check that it is both valid
  # and the attibutes are correct
  def test_new
    parameter_role = ParameterRole.new(NEW_PARAMETER_ROLE)
    assert_kind_of ParameterRole, parameter_role
    assert parameter_role.valid?, "ParameterRole should be valid"
    NEW_PARAMETER_ROLE.each do |attr_name|
      assert_equal NEW_PARAMETER_ROLE[attr_name], parameter_role.attributes[attr_name], "ParameterRole.@#{attr_name.to_s} incorrect"
    end
    assert parameter_role.save
 end


  # Simple test to ensure that the first record is retrieved correctly
  def test_find
    role = ParameterRole.find(:first)
    assert_not_nil role
  end

  # With the name set to nil, this record should not be savable
  def test_bad_save
    parameter_role = ParameterRole.new
    parameter_role.name = nil
    parameter_role.description = "A Description"
    parameter_role.weighing = 0
    assert !parameter_role.save, "Test that record cannot be saved with a nil name"
  end
  
  # Ensures all the required fields have been entered
  def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_parameter_role = NEW_PARAMETER_ROLE.clone
			tmp_parameter_role.delete attr_name.to_sym
			parameter_role = ParameterRole.new(tmp_parameter_role)
			assert !parameter_role.valid?, "ParameterRole should be invalid, as @#{attr_name} is invalid"
    	assert parameter_role.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
   end

  #Check field validation 
  def test_raw_validation
    parameter_role = ParameterRole.new
    if REQ_ATTR_NAMES.blank?
      assert parameter_role.valid?, "ParameterRole should be valid without initialisation parameters"
    else
      # If ParameterRole has validation, then use the following:
      assert !parameter_role.valid?, "ParameterRole should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert parameter_role.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

  # Checks to make sure there are no duplicate fields in the db, as defined in DUPLICATE_ATTR_NAMES
  def test_duplicate
    current_parameter_role = ParameterRole.find(:first)
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		parameter_role = ParameterRole.new(NEW_PARAMETER_ROLE.merge(attr_name.to_sym => current_parameter_role[attr_name]))
			assert !parameter_role.valid?, "ParameterRole should be invalid, as @#{attr_name} is a duplicate"
    	assert parameter_role.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end

end
