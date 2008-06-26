require File.dirname(__FILE__) + '/../test_helper'

class BiorailsTest < Test::Unit::TestCase

  # Replace this with your real tests.
  def setup
     @model = Analysis
  end
  
  def test_biorails_retrieve_db_info
    db,user,password = Biorails::Dba.retrieve_db_info
    assert db
    assert user
    assert password
  end
  
  def test_biorials_export_yaml
    assert Biorails::Dba.export_model(DataElement)
  end

 def test_biorails_backup_db
    db,user,password = Biorails::Dba.retrieve_db_info
    file = Biorails::Dba.backup_db('fixture',user,password )
    assert File.exists?(file)
 end
 
end
