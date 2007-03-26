require File.dirname(__FILE__) + '/../test_helper'
require 'data_contexts_controller'

# Re-raise errors caught by the controller.
class DataContextsController; def rescue_action(e) raise e end; end

class DataContextsControllerTest < Test::Unit::TestCase
  fixtures :data_contexts

  def setup
    @controller = DataContextsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
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

    assert_not_nil assigns(:data_contexts)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:data_context)
    assert assigns(:data_context).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:data_context)
  end

  def test_create
    num_data_contexts = DataContext.count

    post :create, :data_context => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_data_contexts + 1, DataContext.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:data_context)
    assert assigns(:data_context).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil DataContext.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      DataContext.find(1)
    }
  end
end
