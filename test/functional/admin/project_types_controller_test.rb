require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/admin/project_types_controller"

# Re-raise errors caught by the controller.
class ProjectTypesController; def rescue_action(e) raise e end; end

class ProjectTypesControllerTest < Test::Unit::TestCase
  fixtures :project_types

  def setup
    @controller = Admin::ProjectTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 2
    @request.session[:current_user_id] = 3
    @item = ParameterType.find(:first)
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:project_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_project_type
    old_count = ProjectType.count
    post :create, :project_type => {:name=>'test',:description=>'test',:dashboard=>'project' }
    assert_equal old_count+1, ProjectType.count    
    assert_redirected_to project_type_url()
  end

  def test_failed_create_project_type
    old_count = ProjectType.count
    post :create, :project_type => {:name=>nil,:description=>'test',:dashboard=>'project' }
    assert_response :success
    assert_equal old_count, ProjectType.count    
  end
  
  def test_should_show_project_type
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_project_type
    put :update, :id => 1, :project_type => {:name=>'test2',:description=>'test2',:dashboard=>'project' }
    assert_redirected_to project_type_url()
  end

  def test_fail_update_project_type
    put :update, :id => 1, :project_type => {:name=>nil,:description=>'test2',:dashboard=>'project' }
    assert_response :success
  end

  def test_should_destroy_project_type
    old_count = ProjectType.count
    delete :destroy, :id => 1
    assert_equal old_count-1, ProjectType.count    
    assert_redirected_to project_type_url()
  end
  

end
