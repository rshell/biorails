require File.dirname(__FILE__) + '/../test_helper'
# Re-raise errors caught by the controller.
class FormatHelperTest< TestHelper
  include FormatHelper
  
  def setup
    Project.current = Project.find(2)
    User.current = User.find(3)
  end  

  def protect_against_forgery?
    false
  end

  def test_format_time
    html = format_time(Time.now)
    assert html.is_a?(String)
  end

  def test_format_date
    html = format_date(Date.new)
    assert html.is_a?(String)
  end

  def test_day_name
    html = day_name(1)
    assert html.is_a?(String)
  end

  def test_month_name
    html = month_name(3)
    assert html.is_a?(String)
  end

  def test_number_round
    html = number_round(10.1111,3)
    assert html.is_a?(String)
    assert_equal "10.1", html 
  end

  def test_number_round2
    html = number_round(10.5555,3)
    assert html.is_a?(String)
    assert_equal "10.6",html
  end
  
  def test_number_round_error
    html = number_round(:moose,1)
    assert html.is_a?(String)
    assert_equal "#Err",html
  end

  def test_number_round_nil
    html = number_round(nil,1)
    assert html.is_a?(String)
    assert_equal "", html
  end

  
  def test_short_time
    html = short_time(Time.now)
    assert html.is_a?(String)
  end
  
  def test_short_time_not_set
    html = short_time(nil)
    assert html.is_a?(String)
    assert_equal "Not Set", html
  end

  def test_short_time_err
    html = short_time(:moose)
    assert html.is_a?(String)
    assert_equal "#Err", html
  end  
  
  def test_short_date
    html = short_date(Date.new)
    assert html.is_a?(String)
  end
  
  def test_short_date_not_set
    html = short_date(nil)
    assert html.is_a?(String)
    assert_equal "Not Set", html
  end
  
  def test_short_date_err
    html = short_date(:moose)
    assert html.is_a?(String)
    assert_equal "#Err", html
  end

  def test_subject_icon
    html = subject_icon('moose')
    assert html.is_a?(String)
    assert_equal "mock image_tag", html
  end

  def test_subject_icon_with_path
    html = subject_icon('/images/moose.png')
    assert html.is_a?(String)
    assert_equal "mock image_tag", html
  end


end
