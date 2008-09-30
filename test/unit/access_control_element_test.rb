require File.dirname(__FILE__) + '/../test_helper'

class AccessControlElementTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def setup
    assert_ok @element = AccessControlElement.find(:first)
  end
  
  def test_has_role
   assert @element.role
  end

  def test_has_list
   assert @element.access_control_list
  end

  def test_has_owner
   assert @element.owner
  end

  def test_role_name
    assert_equal @element.role.name,@element.role_name
  end

  def test_owner_name
    assert @element.owner_name
  end

  def test_to_s
    assert @element.to_s
  end

end
