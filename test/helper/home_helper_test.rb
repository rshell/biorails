require File.dirname(__FILE__) + '/../test_helper'
# Re-raise errors caught by the controller.
class HomeHelperTest < TestHelper
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
  
  
  def protect_against_forgery?
    false
  end

end
