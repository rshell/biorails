require File.dirname(__FILE__) + '/../test_helper'

class SystemSettingTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :system_settings

  # Replace this with your real tests.
  def test_truth
    assert true
  end  
  
  def test_use_as_property
    SystemSetting.host_name ='xxx'
    assert SystemSetting.find_by_name('host_name').value == 'xxx'
    assert SystemSetting.host_name =='xxx'
  end
  
  def test_use_as_array
    SystemSetting['host_name'] ='Big Deer'
    assert SystemSetting['host_name'] == 'Big Deer'
    assert SystemSetting.find_by_name('host_name').value == 'Big Deer'
  end
end
 