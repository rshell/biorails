require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/data_systems_controller'

# Re-raise errors caught by the controller.
class Admin::DataSystemsController; def rescue_action(e) raise e end; end

class Admin::DataSystemsControllerTest < Test::Unit::TestCase
  fixtures :data_systems
  
  def setup
    @request    = ActionController::TestRequest.new(nil,nil,{:current_user_id => user.id,:current_project_id => project.id})
    @response   = ActionController::TestResponse.new
    @session    = ActionController::TestSession.new
    @controller = DataSystemsController.new(@request,@response,@session)
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

    assert_not_nil assigns(:data_Systems)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:data_System)
    assert assigns(:data_System).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:data_System)
  end

  def test_create
    num_data_Systems = DataSystem.count

    post :create, :data_System => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_data_Systems + 1, DataSystem.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:data_System)
    assert assigns(:data_System).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil DataSystem.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      DataSystem.find(1)
    }
  end
end
