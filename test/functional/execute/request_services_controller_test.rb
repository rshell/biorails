require File.dirname(__FILE__) + '/../../test_helper'
require 'execute/request_services_controller'

# Re-raise errors caught by the controller.
class Execute::RequestServicesController; def rescue_action(e) raise e end; end

class Execute::RequestServicesControllerTest < Test::Unit::TestCase
  fixtures :request_services
  fixtures :users
  fixtures :projects
  fixtures :roles
  fixtures :memberships
  fixtures :role_permissions

  def setup
    @controller = Inventory::CompoundsController.new
    @request    = ActionController::TestRequest.new
    @request.session[:project_id] = Project.find(:first)
    @request.session[:user_id] = User.find(:first)
    @response   = ActionController::TestResponse.new
    @first = RequestService.find(:first)
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:request_services)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:request_service)
    assert assigns(:request_service).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:request_service)
  end

  def test_create
    num_request_services = RequestService.count

    post :create, :request_service => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_request_services + 1, RequestService.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:request_service)
    assert assigns(:request_service).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      RequestService.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      RequestService.find(@first_id)
    }
  end
end
