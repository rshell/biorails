require File.dirname(__FILE__) + '/../test_helper'

class PermissionTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :permissions

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_load_database
    Permission.load_database
  end
  
  def test_load_database
    Permission.controllers
    assert Permission.cached_controllers
    Permission.cached_controllers =nil
    Permission.controllers
    assert Permission.cached_controllers
  end
  
end
