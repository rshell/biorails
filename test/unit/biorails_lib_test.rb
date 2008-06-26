require File.dirname(__FILE__) + '/../test_helper'

class BiorailsLibTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :analysis_settings

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_dba_models
    list = Biorails::Dba.models
    assert list
    assert list.is_a?(Array)
  end
  
  def test_dba_models
    db,user,password = Biorails::Dba.retrieve_db_info
    assert db
    assert user
    assert password    
  end
  
end
