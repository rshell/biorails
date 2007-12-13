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

  def test_show_as_xml
    get :show,{:format=>'xml'},@session    
    assert_response :success
  end
  
  
  def test_calendar_as_html
    get :calendar,nil,@session
    assert_response :success
  end
  
  def test_calendar_as_json
    get :calendar,{:format=>'json'},@session    
    assert_response :success
  end

  def test_calendar_as_js
    get :calendar,{:format=>'js'},@session    
    assert_response :success
  end
  
  def test004_timeline
    post :gantt, @params, @session
    assert_response :success
  end
  
  def test005_projects
    get :projects
    assert_response :success
  end

  def test006_news
    post :news,  @params, @session
    assert_response :success
  end  

  def test007_requests
    get :todo,nil,@session
    assert_response :success
  end
  
  def test008_tasks
    get :todo,nil,@session
    assert_response :success
  end
  
  def test009_blog
    get :blog,nil,@session
    assert_response :success
  end

  def test010_tree
    get :tree,{:node=>'root'},@session
    assert_response :success
  end
    
end
