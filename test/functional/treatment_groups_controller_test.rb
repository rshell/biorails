require File.dirname(__FILE__) + '/../test_helper'
require 'treatment_groups_controller'

# Re-raise errors caught by the controller.
class TreatmentGroupsController; def rescue_action(e) raise e end; end

class TreatmentGroupsControllerTest < Test::Unit::TestCase
  fixtures :treatment_groups

  def setup
    @controller = TreatmentGroupsController.new
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

    assert_not_nil assigns(:treatment_groups)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:treatment_group)
    assert assigns(:treatment_group).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:treatment_group)
  end

  def test_create
    num_treatment_groups = TreatmentGroup.count

    post :create, :treatment_group => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_treatment_groups + 1, TreatmentGroup.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:treatment_group)
    assert assigns(:treatment_group).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil TreatmentGroup.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      TreatmentGroup.find(1)
    }
  end
end
