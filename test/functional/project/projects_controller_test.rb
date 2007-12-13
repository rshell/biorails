require File.dirname(__FILE__) + '/../../test_helper'
require  "projects_controller"

# Re-raise errors caught by the controller.
class Project::ProjectsController; def rescue_action(e) raise e end; end

class Project::ProjectsControllerTest < Test::Unit::TestCase
  # # fixtures :users
  # # fixtures :roles
  # # fixtures :role_permissions
  # # fixtures :permissions
  # # fixtures :projects

  def setup
    @controller = Project::ProjectsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @item = Project.find(:first)
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def fill_session_user
    user = User.find(:first)
    @request.session[:user_id] = user.id
  end
  
  def fill_session_project
    project = Project.find(:first)
    @request.session[:project_id] = project.id
  end

  def test001_setup
    fill_session_project
    fill_session_user
    assert_not_nil @controller
    assert_not_nil @response
    assert_not_nil @request
    assert_not_nil @request.session[:user_id]
    assert_not_nil @request.session[:project_id]
  end
  
  def test_list
    fill_session_user
    get :list
    assert_response :success
  end

  def test_index
    fill_session_user
    get :index
    assert_response :success
  end

  def test_get_index_as_xml
    fill_session_user
    get :index,{:format=>'xml'}
    assert_response :success
  end

  def test_get_index_as_csv
    fill_session_user
    get :index,{:format=>'csv'}
    assert_response :success
  end
  
  def test003_new
    get :new
    assert_response :success
  end

  def test_get_show
    get :show ,:id=>@item.id
    assert_response :success
  end

  def test_get_show_as_json
    get :show ,:id=>@item.id,:format=>'json'
    assert_response :success
  end

  def test_get_show_as_xml
    get :show ,:id=>@item.id,:format=>'xml'
    assert_response :success
  end
  
  def test_get_show_as_js
    get :show ,:id=>@item.id,:format=>'js'
    assert_response :success
  end

   def test_get_new
    get :new 
    assert_response :success
  end

  def test_get_edit
    get :new 
    assert_response :success
  end
  
  def test_get_members
    get :new 
    assert_response :success
  end
    
    def test_calendar_as_html
    get :calendar,:id=>@item.id
    assert_response :success
  end
  
  def test_calendar_as_json
    get :calendar,{:format=>'json',:id=>@item.id}
    assert_response :success
  end

  def test_calendar_as_js
    get :calendar,{:id=>@item.id,:format=>'js'}
    assert_response :success
  end
  
 def test_get_gantt
    get :gantt,{:id=>@item.id,:format=>'js'}
    assert_response :success
  end

 def test_get_tree
    get :tree,:id=>@item.id
    assert_response :success
  end
 
end
