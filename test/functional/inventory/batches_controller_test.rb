require File.dirname(__FILE__) + '/../../test_helper'
require 'inventory/batches_controller'

# Re-raise errors caught by the controller.
class Inventory::BatchesController; def rescue_action(e) raise e end; end

class BatchesControllerTest < Test::Unit::TestCase
  fixtures :batches

  fixtures :compounds
  fixtures :users
  fixtures :projects
  fixtures :roles
  fixtures :memberships
  fixtures :role_permissions

  def setup
    @controller = Inventory::CompoundsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
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

    assert_not_nil assigns(:batches)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:batch)
    assert assigns(:batch).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:batch)
  end

  def test_create
    num_batches = Batch.count

    post :create, :batch => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_batches + 1, Batch.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:batch)
    assert assigns(:batch).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Batch.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Batch.find(1)
    }
  end
end
