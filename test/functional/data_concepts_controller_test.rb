require File.dirname(__FILE__) + '/../test_helper'
require 'data_concepts_controller'

# Re-raise errors caught by the controller.
class DataConceptsController; def rescue_action(e) raise e end; end

class DataConceptsControllerTest < Test::Unit::TestCase
  fixtures :data_concepts

  def setup
    @controller = DataConceptsController.new
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

    assert_not_nil assigns(:data_concepts)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:data_concept)
    assert assigns(:data_concept).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:data_concept)
  end

  def test_create
    num_data_concepts = DataConcept.count

    post :create, :data_concept => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_data_concepts + 1, DataConcept.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:data_concept)
    assert assigns(:data_concept).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil DataConcept.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      DataConcept.find(1)
    }
  end
end
