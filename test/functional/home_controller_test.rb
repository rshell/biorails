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
  
  def test_setup
    assert_not_nil @controller
    assert_not_nil @response
    assert_not_nil @request
  end
  
  def test_show
    get :show,nil,@session
    assert_response :success
  end

  def test_show_no_user
    @session = @request.session || []
    @request.session[:current_project_id] = nil
    @request.session[:current_user_id] = nil
    get :show,nil,@session
    assert_response :redirect
    assert_redirected_to :action=>'login'
  end
  
   def test_index
    get :index,nil,@session
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
  
  def test_gantt
    post :gantt
    assert_response :success
  end

  def test_gantt_set_options
    post :gantt,:month=>2,:year=>2007
    assert_response :success
  end
  
  def test_news
    post :news,  @params, @session
    assert_response :success
  end  

  def test_news_ajax
    post :news, :format=>'js'
    assert_response :success
  end  

  def test_news_xml
    post :news, :format=>'xml'
    assert_response :success
  end  

  def test_todo
    get :todo
    assert_response :success
  end
  
  def test_todo_ajax
    get :todo, :format=>'js'
    assert_response :success
  end
  
  def test_todo_xml
    get :todo, :format=>'xml'
    assert_response :success
  end
  
  def test_tasks
    get :tasks
    assert_response :success
  end
  
  def test_tasks_ajax
    get :tasks, :format=>'js'
    assert_response :success
  end
  
  def test_tasks_xml
    get :tasks, :format=>'xml'
    assert_response :success
  end
  
  def test_tree_root
    get :tree,{:node=>'root'},@session
    assert_response :success
  end

  def test_tree_level
    folder = ProjectFolder.find(:first)      
    get :tree,{:node=>folder.id},@session
    assert_response :success
  end
    
  def test_requests
    get :requests
    assert_response :success
  end

  def test_requests_ajax
    get :requests,:format=>'js'
    assert_response :success
  end

  def test_requests_xml
    get :requests,:format=>'xml'
    assert_response :success
  end

  def test_timeline
    @params = {'year'=>2007,'month'=>11,}
    post :gantt, @params, @session
    assert_response :success
  end

   
end

