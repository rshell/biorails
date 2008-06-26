require File.dirname(__FILE__) + '/../test_helper'
require 'application'

# Re-raise errors caught by the controller.
class ApplicationController; def rescue_action(e) raise e end; end

class ApplicationControllerTest < Test::Unit::TestCase
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ApplicationHelper
  
  def setup
    @controller = ApplicationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
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
  
  def test_set_folder_invalid_id
    assert_equal nil,@controller.send(:set_folder,4545)
  end  

  def test_set_folder_exception_handled
    assert_equal nil,@controller.send(:set_folder,nil)
  end  

  def test_set_team_exception_handled
    assert_equal nil,@controller.send(:set_team,nil)
  end  

  def test_set_team_exception_handled
    assert_equal nil,@controller.send(:set_user,nil)
  end  

  def test_current_exception_handled
    assert_equal nil,@controller.send(:current,nil)
  end  

  def test_current_user
    assert_equal User.find(1),@controller.send(:current_user)
  end  

  def test_current_project
    assert_equal Project.find(1),@controller.send(:current_project)
  end  

end
