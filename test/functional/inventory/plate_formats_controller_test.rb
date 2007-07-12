require File.dirname(__FILE__) + '/../../test_helper'
require 'inventory/plate_formats_controller'

# Re-raise errors caught by the controller.
class Inventory::PlateFormatsController; def rescue_action(e) raise e end; end

class Inventory::PlateFormatsControllerTest < Test::Unit::TestCase
  fixtures :plate_formats

  fixtures :compounds
  fixtures :users
  fixtures :projects
  fixtures :roles
  fixtures :memberships
  fixtures :role_permissions

  def setup
    @controller = Inventory::PlateFormatsController.new
    @request    = ActionController::TestRequest.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
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

    assert_not_nil assigns(:plate_formats)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:plate_format)
    assert assigns(:plate_format).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:plate_format)
  end

  def test_create
    num_plate_formats = PlateFormat.count

    post :create, :plate_format => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_plate_formats + 1, PlateFormat.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:plate_format)
    assert assigns(:plate_format).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil PlateFormat.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      PlateFormat.find(1)
    }
  end
end
