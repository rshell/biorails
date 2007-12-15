require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/execute/request_services_controller"

# Re-raise errors caught by the controller.
class Execute::RequestServicesController; def rescue_action(e) raise e end; end

class Execute::RequestServicesControllerTest < Test::Unit::TestCase
  # # fixtures :request_services
  # # fixtures :users
  # # fixtures :projects
  # # fixtures :roles
  # # fixtures :memberships
  # # fixtures :role_permissions

  def setup
    @controller = Execute::RequestServicesController.new
    @request    = ActionController::TestRequest.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @response   = ActionController::TestResponse.new
    @first = RequestService.find(:first)
  end

  def test_setup
    assert_not_nil @controller
    assert_not_nil @request
    assert_not_nil @response
    assert_not_nil @first , "Missing a valid fixture for this controller"
    assert_not_nil @first.id
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
    get :show, :id => @first.id

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

    assert_response :success
    assert_template 'new'

    assert_equal num_request_services , RequestService.count
  end

  def test_edit
    get :edit, :id => @first.id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:request_service)
    assert assigns(:request_service).valid?
  end

  def test_update
    post :update, :id => @first.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first.id
  end

  def test_destroy
    RequestService.transaction do
        assert_nothing_raised {
          RequestService.find(@first.id)
        }

        post :destroy, :id => @first.id
        assert_response :redirect
        assert_redirected_to :action =>'show'

        assert_raise(ActiveRecord::RecordNotFound) {
          RequestService.find(@first.id)
        }
     #raise ActiveRecord::Rollback 
    end  
  end
end

