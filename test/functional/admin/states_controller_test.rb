require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/admin/states_controller"

# Re-raise errors caught by the controller.
class Admin::StatesController; def rescue_action(e) raise e end; end

class Admin::StatesControllerTest < Test::Unit::TestCase

  def setup
    @controller = Admin::StatesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @model = State
    @item = State.create(:name=>'test',:description=>'test',
      :is_default=>true,:position=>1,:level_no=>1)
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
    num = State.count
    post :create, :data_type => {}
    assert_response :success
    assert_template 'new'
    assert_equal num , @model.count
  end

  def test_create_succeeded
    num = @model.count
    post :create,  :state=>{:name=>'hello', :description=>'hello2'}
    assert_response :redirect
    assert_redirected_to :action=> 'list'
    assert_equal num+1 , @model.count
  end

  def test_edit_success
    post :update, :id => @item.id, :state=>{:name=>'hello', :description=>'hello2'}
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end

  def test_edit_fail
    post :update, :id => @item.id, :state=>{:name=>nil, :description=>'hello2'}
    assert_response :success
    assert_template 'edit'
  end

  def test_update
    get :edit, :id => @item.id
    assert_response :success
    assert_template 'edit'
  end

  def test_destroy
    assert_not_nil @model.find(@item.id)
    post :destroy, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end
end
