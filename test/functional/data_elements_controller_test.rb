require File.dirname(__FILE__) + '/../test_helper'
require 'data_elements_controller'

# Re-raise errors caught by the controller.
class DataElementsController; def rescue_action(e) raise e end; end

class DataElementsControllerTest < Test::Unit::TestCase
  fixtures :data_elements

  def setup
    @controller = DataElementsController.new
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

    assert_not_nil assigns(:data_elements)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:data_element)
    assert assigns(:data_element).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:data_element)
  end

  def test_create
    num_data_elements = DataElement.count

    post :create, :data_element => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_data_elements + 1, DataElement.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:data_element)
    assert assigns(:data_element).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil DataElement.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      DataElement.find(1)
    }
  end
end
