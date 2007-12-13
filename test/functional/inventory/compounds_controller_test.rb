require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/inventory/compounds_controller"

# Re-raise errors caught by the controller.
class Inventory::CompoundsController; def rescue_action(e) raise e end; end

class Inventory::CompoundsControllerTest < Test::Unit::TestCase

  # fixtures :compounds
  # fixtures :users
  # fixtures :projects
  # fixtures :roles
  # fixtures :memberships
  # fixtures :role_permissions

  def setup
    @controller = Inventory::CompoundsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @item = Compound.find(:first)
  end

  def test_setup
    assert_not_nil @controller
    assert_not_nil @request
    assert_not_nil @response
    assert_not_nil @item , "Missing a valid fixture for this controller"
    assert_not_nil @item.id
    assert_not_nil Compound.count > 1
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
    assert_not_nil assigns(:compounds)
  end

  def test_show
    get :show, :id => @item.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:compound)
    assert assigns(:compound).valid?
  end

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:compound)
  end

  def test_create
    num_compounds = Compound.count
    post :create, :compound => {}
    assert_response :success
    assert_template 'new'
    assert_equal num_compounds , Compound.count
  end

  def test_edit
    get :edit, :id => @item.id
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:compound)
    assert assigns(:compound).valid?
  end

  def test_update
    post :update, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @item.id
  end

  def test_destroy
    Compound.transaction do
      assert_not_nil Compound.find(1)
      post :destroy, :id => @item.id
      assert_response :redirect
      assert_redirected_to :action => 'list'
      assert_raise(ActiveRecord::RecordNotFound) {
        Compound.find(1)
      }
    end
  end
end
