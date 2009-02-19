require File.dirname(__FILE__) + '/../test_helper'
# Re-raise errors caught by the controller.
class ReportsHelper < BiorailsTestCase
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::PrototypeHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::CaptureHelper
  include ApplicationHelper
  include Execute::ReportsHelper
  
  def setup
    Project.current = Project.find(2)
    User.current = User.find(3)
  end  
  
  def report_url(*arg)
    "mock"  
  end

  def url_for(*arg)
    "mock"  
  end
  
  def protect_against_forgery?
    false
  end
  
  def test_column_header
    @report = Report.find(:first)
    for column in @report.columns
      assert column_header(@report,column)
    end
  end

  def test_column_filter
    @report = Report.find(:first)
    for column in @report.columns
      column_filter(@report,column)
    end
  end

  def test_columns_to_json
    @report = Report.find(:first)
    html = columns_to_json(@report,@report.model)
    assert html.is_a?(String)
    assert html.size>0
  end
  
end
