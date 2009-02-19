require File.dirname(__FILE__) + '/../test_helper'

class SystemSettingsTest < BiorailsTestCase
  ## Biorails::Dba.import_model :system_settings
  
  def test_all
    list = SystemSetting.all
    assert list
    assert list.size>0
  end
  
end
