require File.dirname(__FILE__) + '/../test_helper'

class PermissionTest < Test::Unit::TestCase
  fixtures :permissions

  NEW_PERMISSION = {:name => 'Test Permission'}
  DUPLICATE_ATTR_NAMES = %w( name ) # name of fields that cannot be a duplicate, e.g. %(name description)
  
 
  
  # Create a new permission and check that it is both valid
  # and the attibutes are correct
  def test_new
    permission = Permission.new(NEW_PERMISSION)
    assert_kind_of Permission, permission
    assert permission.valid?, "Permission should be valid"
    NEW_PERMISSION.each do |attr_name|
      assert_equal NEW_PERMISSION[attr_name], permission.attributes[attr_name], "Permission.@#{attr_name.to_s} incorrect"
    end
    assert permission.save
 end

  # Simple test to ensure that the first record is retrieved correctly
  def test_find
    permission = Permission.find(1)
    assert_equal "Administer site", permission.name #, 'Bad match on permission name'
  end

  # Checks to make sure there are no duplicate fields in the db, as defined in DUPLICATE_ATTR_NAMES
  def test_duplicate
    current_permission = Permission.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		permission = Permission.new(NEW_PERMISSION.merge(attr_name.to_sym => current_permission[attr_name]))
			assert !permission.valid?, "Permission should be invalid, as @#{attr_name} is a duplicate"
    	assert permission.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end

end
