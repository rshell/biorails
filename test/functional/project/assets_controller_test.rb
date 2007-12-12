require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/project/assets_controller"

# Re-raise errors caught by the controller.
class Project::AssetsController; def rescue_action(e) raise e end; end

class Project::AssetsControllerTest < Test::Unit::TestCase
  def setup
    @controller = Project::AssetsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @model = ProjectAsset
    @item = @model.find(:first)
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  #
  # Test a index call to controller
  #
  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  #
  # Test a list call to controller
  #
  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:memberships)
  end

  #
  # Test a show of a item
  #
  def test_show
    get :show, :id => @item.id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:membership)
    assert assigns(:membership).valid?
  end

  #
  # Test a new call to controller
  #
  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:membership)
  end

  #
  # Test a edit call to controller
  #
  def test_edit
    get :edit, :id =>  @item.id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:membership)
    assert assigns(:membership).valid?
  end

  #
  # Test a update call to controller
  #
  def test_update
    post :update, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  #
  # Test a destroy call to controller
  #
  def test_destroy
    assert_nothing_raised {      @model.find( @item.id)    }

    post :destroy, :id =>  @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      @model.find( @item.id)
    }
  end
end
