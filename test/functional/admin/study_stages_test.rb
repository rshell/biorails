require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/admin/parameter_types_controller"

# Re-raise errors caught by the controller.
class Admin::ParameterTypesController; def rescue_action(e) raise e end; end

class Admin::ParameterTypesControllerTest < Test::Unit::TestCase
  # # fixtures :parameter_types

	NEW_PARAMETER_TYPE = {}	# e.g. {:name => 'Test ParameterType', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = Admin::ParameterTypesController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @item = ParameterType.find(:first)
  end

  def test_truth
    assert true
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
    num = ParameterType.count
    post :create, :data_type => {}
    assert_response :success
    assert_template 'new'
    assert_equal num , ParameterType.count
  end

  def test_edit
    get :edit, :id => @item.id
    assert_response :success
    assert_template 'edit'
  end

  def test_update
    post :update, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @item.id
  end

  def test_destroy
    assert_not_nil ParameterType.find(@item.id)
    post :destroy, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end

  end
