require File.dirname(__FILE__) + '/../test_helper'

class BiorailsLibTest < BiorailsTestCase
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
  end
  
  def test_utf8_to_codepage
    x = 3543252352
    y = Biorails.utf8_to_codepage(x)
    assert_equal x,y
  end

  def test_logger
    x = ActiveRecord::Base.logger
    Biorails::Dba.logger = x
    assert_equal x,Biorails::Dba.logger
  end

  def test_importing
    assert !Biorails::Dba.importing?
  end

  def test_htmldoc
    Biorails::Check.htmldoc_status
  end

  def test_graphviz_status
    Biorails::Check.graphviz_status
  end

  def test_image_magick_status
    Biorails::Check.image_magick_status
  end

  def test_db_test
    assert Biorails::Check.oracle? || Biorails::Check.mysql?
  end
end
