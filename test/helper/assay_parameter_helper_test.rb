
require File.dirname(__FILE__) + '/../test_helper'
# Re-raise errors caught by the controller.
class AssayParametersHelperTest< TestHelper
  include Organize::AssayParametersHelper
  
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

  def test_assay_parameters_to_json
    @items = AssayParameter.find(:all)
    html = assay_parameters_to_json(@items)
    assert html.is_a?(String)
    assert html.size>0
  end

  def test_assay_queues_to_json
    @items = AssayQueue.find(:all)
    html = assay_queues_to_json(@items)
    assert html.is_a?(String)
    assert html.size>0
  end
  
    def test_parameter_roles_to_json
    @items = AssayParameter.find(:all)
    html = parameter_roles_to_json(@items)
    assert html.is_a?(String)
    assert html.size>0
  end

end
