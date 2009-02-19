require File.dirname(__FILE__) + '/../test_helper'
require 'application'

# Re-raise errors caught by the controller.
class ApplicationController; def rescue_action(e) raise e end; end

class ApplicationControllerTest < BiorailsTestCase
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ApplicationHelper
  
  def setup
    @controller = ApplicationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    Project.current = Project.find(1)
    @request.session[:current_project_id] = 1
    User.current = User.find(3)
    @request.session[:current_user_id] = 3
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_browser_name
    assert_equal 'test', @controller.send(:browser_name,@request)
  end

  def test_authorize
    assert @controller.send(:authorize)
  end

  def test_browser_name_mozilla
    @request.env['HTTP_USER_AGENT']='mozilla/safsfsa'
    assert_equal 'gecko', @controller.send(:browser_name,@request)
  end
  
  def test_browser_name_gecko
    @request.env['HTTP_USER_AGENT']='gecko/sfsaf'
    assert_equal 'gecko',@controller.send(:browser_name,@request)
  end

  def test_browser_name_opera
    @request.env['HTTP_USER_AGENT']='opera'
    assert_equal 'opera', @controller.send(:browser_name,@request)
  end

  def test_browser_name_ie
    @request.env['HTTP_USER_AGENT']='msie-6'
    assert_equal 'ie6',@controller.send(:browser_name,@request)
  end

  def test_browser_name_safari

    @request.env['HTTP_USER_AGENT']=' /applewebkit/safsfsa'
    assert_equal 'safari',@controller.send(:browser_name,@request)

  end
  def test_set_element_invalid_id
    assert_equal nil,@controller.send(:set_element,4545)
  end  

  def test_set_element_exception_handled
    assert_equal nil,@controller.send(:set_element,nil)
  end  

  def test_set_user_handled
    assert_equal nil,@controller.send(:set_user,nil)
  end  

  def test_current_exception_handled
    assert_equal nil,@controller.send(:current,nil)
  end  

  def test_current_user
    item = @controller.send(:current_user)
    assert item.is_a?(User)
    assert_equal 3,item.id
  end  

  def test_current_project
    assert_equal Project.find(1),@controller.send(:current_project)
  end  

  def test_object_to_url
    item = @controller.send(:object_to_url,nil)
    assert "",item
  end

end
