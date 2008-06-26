require File.dirname(__FILE__) + '/../test_helper'

class UserSettingTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :system_settings
  
  def test_use_as_property
    UserSetting.host_name ='xxx'
    assert UserSetting.find_by_name('host_name').value == 'xxx'
    assert UserSetting.host_name =='xxx'
  end
  
  def test_use_as_array
    UserSetting['host_name'] ='Big Deer'
    assert UserSetting['host_name'] == 'Big Deer'
    assert UserSetting.find_by_name('host_name').value == 'Big Deer'
  end
end
 