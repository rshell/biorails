require File.dirname(__FILE__) + '/../../test_helper'
require  "#{RAILS_ROOT}/app/controllers/project/projects_controller"

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
  
  def test002_index
    fill_session_user
    get :list
    assert_response :success
  end
  
  def test003_new
    get :new
    assert_response :success
  end

  def test003_show
    get :show ,:id=>@item.id
    assert_response :success
  end

  def test004_calendar
    get :calendar ,:id=>@item.id
    assert_response :success
  end
   
  
end
