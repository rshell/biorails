require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/inventory/containers_controller"

# Re-raise errors caught by the controller.
class Inventory::ContainersController; def rescue_action(e) raise e end; end

class Inventory::ContainersControllerTest < Test::Unit::TestCase
  # fixtures :containers

  # fixtures :compounds
  # fixtures :users
  # fixtures :projects
  # fixtures :roles
  # fixtures :memberships
  # fixtures :role_permissions

  def setup
    @controller = Inventory::ContainersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @item = Container.find(:first)
  end

  def test_setup
    assert_not_nil @controller
    assert_not_nil @request
    assert_not_nil @response
    assert_not_nil @item , "Missing a valid fixture for this controller"
    assert_not_nil @item.id
    assert_not_nil Container.count > 1
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
    assert_not_nil assigns(:containers)
  end

  def test_show
    get :show, :id => @item.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:container)
    assert assigns(:container).valid?
  end

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:container)
  end

  def test_create
    num_containers = Container.count
    post :create, :container => {}
    assert_response :success
    assert_template 'new'
    assert_equal num_containers, Container.count
  end

  def test_edit
    get :edit, :id => @item.id
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:container)
    assert assigns(:container).valid?
  end

  def test_update
    post :update, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @item.id
  end

  def test_destroy
    Container.transaction do
        assert_not_nil Container.find(@item.id)
        post :destroy, :id => @item.id
        assert_response :redirect
        assert_redirected_to :action => 'list'
        assert_raise(ActiveRecord::RecordNotFound) {
          Container.find(@item.id)
        }
    end
  end
end
