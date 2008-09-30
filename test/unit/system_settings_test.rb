require File.dirname(__FILE__) + '/../test_helper'

class SystemSettingsTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :system_settings

  # Replace this with your real tests.
  def test_should_set_system_setting
    assert_equal SystemSetting.get("ldap_auto_register").value, false
    SystemSetting.set("ldap_auto_register","true")
    assert_equal SystemSetting.get("ldap_auto_register").value, "true"
  end
  
  def test_all
    list = SystemSetting.all
    assert list
    assert list.size>0
  end
  
end
