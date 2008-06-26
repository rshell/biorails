require File.dirname(__FILE__) + '/../test_helper'

class AnalysisSettingTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :analysis_settings

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_find
    setting = AnalysisSetting.find(:first)
    assert setting
    assert_ok setting
  end  

  def test_script?
    setting = AnalysisSetting.find(:first)
    assert !setting.script? 
  end
  
  def test_mode
    setting = AnalysisSetting.find(:first)
    assert setting.mode
    setting.mode=3
    assert setting.input?
    assert setting.output?
  end
  
  def test_io_style
    setting = AnalysisSetting.find(:first)
    setting.mode=1
    assert_equal '[in]', setting.io_style
    setting.mode=2
    assert_equal '[out]', setting.io_style
    setting.mode=3
    assert_equal '[in/out]', setting.io_style
    setting.mode=0
    assert_equal '[script]', setting.io_style
  end
  
  def test_style
    setting = AnalysisSetting.find(:first)
    setting.mode=1
    setting.level_no=0
    assert_equal 'Value [in]',setting.style
    setting.level_no=1
    assert_equal 'Array [in]',setting.style
    setting.level_no=-1
    assert_equal 'Manual [in]',setting.style
  end
  
end
