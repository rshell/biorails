require File.dirname(__FILE__) + '/../../test_helper'
require 'inventory/specimens_controller'

# Re-raise errors caught by the controller.
class Inventory::SpecimensController; def rescue_action(e) raise e end; end

class Inventory::SpecimensControllerTest < Test::Unit::TestCase
  fixtures :specimens
  fixtures :compounds
  fixtures :users
  fixtures :projects
  fixtures :roles
  fixtures :memberships
  fixtures :role_permissions

  def setup
    @controller = Inventory::CompoundsController.new
    @request    = ActionController::TestRequest.new
    @request.session[:project_id] = Project.find(:first)
    @request.session[:user_id] = User.find(:first)
    @response   = ActionController::TestResponse.new
    @first = Specimen.find(:first)
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

    assert_not_nil assigns(:specimens)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:specimen)
    assert assigns(:specimen).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:specimen)
  end

  def test_create
    num_specimens = Specimen.count

    post :create, :specimen => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_specimens + 1, Specimen.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:specimen)
    assert assigns(:specimen).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Specimen.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Specimen.find(1)
    }
  end
end
