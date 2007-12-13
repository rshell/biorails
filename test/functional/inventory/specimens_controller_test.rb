require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/inventory/specimens_controller"

# Re-raise errors caught by the controller.
class Inventory::SpecimensController; def rescue_action(e) raise e end; end

class Inventory::SpecimensControllerTest < Test::Unit::TestCase
  # fixtures :specimens
  # fixtures :compounds
  # fixtures :users
  # fixtures :projects
  # fixtures :roles
  # fixtures :memberships
  # fixtures :role_permissions

  def setup
    @controller = Inventory::CompoundsController.new
    @request    = ActionController::TestRequest.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @response   = ActionController::TestResponse.new
    @item = Specimen.find(:first)
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
    num_specimens = Specimen.count
    post :create, :specimen => {}
    assert_response :success
    assert_template 'new'
    assert_equal num_specimens , Specimen.count
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
    assert_not_nil Specimen.find(@item.id)
    post :destroy, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end
  
end
