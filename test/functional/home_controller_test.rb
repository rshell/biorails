require File.dirname(__FILE__) + '/../test_helper'
require "home_controller"

# Re-raise errors caught by the controller.
class HomeController; def rescue_action(e) raise e end; end

class HomeControllerTest < Test::Unit::TestCase

  def setup
    @controller = HomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    User.current = User.find(3)
    @item = ProjectContent.list(:first,:conditions=>"parent_id is not null")
    @folder = @item.parent   
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
    get :show
    assert_response :success
  end

  def test_show_no_user
    @request.session[:current_project_id] = nil
    @request.session[:current_user_id] = nil
    get :show
    assert_response :redirect
    assert_redirected_to :action=>'login'
  end
  
   def test_index
    get :index
    assert_response :success
  end

  def test_show_as_xml
    get :show,:format=>'xml'
    assert_response :success
  end 
  
  def test_calendar_as_html
    get :calendar
    assert_response :success
  end
  
  def test_calendar_as_json
    get :calendar,:format=>'json'
    assert_response :success
  end

  def test_calendar_as_js
    get :calendar,:format=>'js'
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
    post :news
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
    get :tree,{:node=>'root'}
    assert_response :success
  end

  def test_tree_level
    folder = ProjectFolder.find(:first)      
    get :tree,:node=>folder.id
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
    post :gantt, :year=>2007,:month=>11
    assert_response :success
  end

   
end

