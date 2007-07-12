require File.dirname(__FILE__) + '/../test_helper'
require 'home_controller'

# Re-raise errors caught by the controller.
class HomeController; def rescue_action(e) raise e end; end

class HomeControllerTest < Test::Unit::TestCase

  def setup
    @controller = HomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @session = @request.session || []
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test001_setup
    assert_not_nil @controller
    assert_not_nil @response
    assert_not_nil @request
  end
  
  def test002_show
    get :show,nil,@session
    assert_response :success
  end
  
  def test003_calendar
    get :calendar,nil,@session
    assert_response :success
  end

  def test004_timeline
    post :timeline, @params, @session
    assert_response :success
  end
  
  def test005_projects
    get :projects
    assert_response :success
  end

  def test006_blog
    post :blog,  @params, @session
    assert_response :success
  end  
  
  def test007_controller
    get :show,nil,@session
    assert_not_nil @controller.current_user
    assert_not_nil @controller.current_user.id

    assert_not_nil @controller.class.rights_subject
    assert_not_nil @controller.class.rights_actions
    assert @controller.logged_in?
    
    
    assert  @controller.authorized?(:show)     
    assert  @controller.authorized?(:calendar)     
    assert  @controller.authorized?(:timeline)     
    assert  @controller.authorized?('blog') 
        
    
  end
  
end
