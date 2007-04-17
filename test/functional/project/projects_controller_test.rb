require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/users_controller'

# Re-raise errors caught by the controller.
class Admin::UsersController; def rescue_action(e) raise e end; end

class Admin::UsersControllerTest < Test::Unit::TestCase
  fixtures :users
  fixtures :roles
  fixtures :role_permissions
  fixtures :permissions
  fixtures :projects

  def setup
    @controller = Admin::UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
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
    get :index
    assert_response :success
  end
  
  def test003_new
    get :new
    assert_response :success
  end
#
#  def test004_create
#    post :create, :user => {:name =>'test3',:password =>'test3', :login =>'test3', :role_id => 3}
#    assert_response :success
#  end
#  
#  def test005_edit
#    get :edit
#    assert_response :success
#  end
#
#  def test006_update
#    post :update, :user => {:name =>'test3',:password =>'test3', :login =>'test3', :role_id => 3}
#    assert_response :success
#  end
#  
  
end
