require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/inventory/treatment_groups_controller"

# Re-raise errors caught by the controller.
class Inventory::TreatmentGroupsController; def rescue_action(e) raise e end; end

class Inventory::TreatmentGroupsControllerTest < Test::Unit::TestCase

  def setup
    @controller = Inventory::TreatmentGroupsController.new
    @request    = ActionController::TestRequest.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @response   = ActionController::TestResponse.new
    @item = TreatmentGroup.find(:first)
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
    get :show, :id => @item.id
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
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:treatment_group)
    assert_equal num_treatment_groups, TreatmentGroup.count
  end

  def test_edit
    get :edit, :id => @item.id
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:treatment_group)
    assert assigns(:treatment_group).valid?
  end

  def test_update
    post :update, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @item.id
  end

  def test_destroy
    assert_not_nil TreatmentGroup.find(@item.id)
    post :destroy, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list'
    assert_raise(ActiveRecord::RecordNotFound) {
      TreatmentGroup.find(@item.id)
    }
  end
end
