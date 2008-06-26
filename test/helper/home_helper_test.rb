require File.dirname(__FILE__) + '/../test_helper'
# Re-raise errors caught by the controller.
class HomeHelperTest < Test::Unit::TestCase
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
  include HomeHelper  
  
  def setup
    Project.current = Project.find(2)
    User.current = User.find(3)
  end  
  
  def report_url(*arg)
    "mock"  
  end
  def project_url(*arg)
    "mock"  
  end
  def assay_url(*arg)
    "mock"  
  end
  def content_url(*arg)
    "mock"  
  end
  def asset_url(*arg)
    "mock"  
  end
  def folder_url(*arg)
    "mock"  
  end
  def assay_parameter_url(*arg)
    "mock"  
  end
  def experiment_url(*arg)
    "mock"  
  end
  def protocol_url(*arg)
    "mock"  
  end
  def task_url(*arg)
    "mock"  
  end
  def report_url(*arg)
    "mock"  
  end
  def request_url(*arg)
    "mock"  
  end
  def compound_url(*arg)
    "mock"  
  end
  def url_for(*arg)
    "mock"  
  end
  
  def protect_against_forgery?
    false
  end

  def test_selements_to_json
    @items = ProjectElement.find(:all)
    html = elements_to_json(@items)
    assert html.is_a?(String)
    assert html.size>0
  end

end
