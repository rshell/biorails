require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/admin/state_flows_controller"

# Re-raise errors caught by the controller.
class Admin::StateFlowsController; def rescue_action(e) raise e end; end

class Admin::StateFlowsControllerTest < Test::Unit::TestCase

  def setup
    @controller = Admin::StateFlowsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @model = StateFlow
    @item = StateFlow.create(:name=>'test',:description=>'test')
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
  end

  def test_show
    get :show, :id => @item.id
    assert_response :success
    assert_template 'show'
  end

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
  end

  def test_create_failed
    num = @model.count
    post :create, :state_flow => {}
    assert_response :success
    assert_template 'new'
    assert_equal num , @model.count
  end

  def test_create_succeeded
    num = @model.count
    post :create,  :state_flow=>{:name=>'hello', :description=>'hello2'}
    assert_response :redirect
    assert_redirected_to :action=> 'list'
    assert_equal num+1 , @model.count
  end

  def test_edit
    get :edit, :id => @item.id
    assert_response :success
    assert_template 'edit'
  end

  def test_update
    post :update, :id => @item.id, :state_flow=>{ :description=>'hello2'}, :state=>{}
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

  def test_update_with_states
    post :update, :id => @item.id, :state_flow=>{ :description=>'hello2'}, :state=>{1=>[1,2,3]}
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

  def test_destroy
    assert_not_nil @model.find(@item.id)
    post :destroy, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end
  def test_destroy_invalid
    assert_not_nil @model.find(@item.id)
    post :destroy
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end
end
