require File.dirname(__FILE__) + '/../test_helper'

class PermissionTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :permissions

  
  def test_load_database
    assert Permission.load_database
  end
  
  
end
