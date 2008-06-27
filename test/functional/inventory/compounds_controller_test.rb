require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/inventory/compounds_controller"

# Re-raise errors caught by the controller.
class Inventory::CompoundsController; def rescue_action(e) raise e end; end

class Inventory::CompoundsControllerTest < Test::Unit::TestCase


 def setup
    @controller = Inventory::CompoundsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 2
    @request.session[:current_user_id] = 3
    @item = Compound.find(:first)
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
    num = Compound.count
    post :create, :compound => {}
    assert_response :success
    assert_template 'new'
    assert_equal num , Compound.count
  end
  
  
  def test_create_succeeded
    num = Compound.count
    post :create,  :compound =>{:name=>'hello', :description=>'hello2'}
    assert_response :redirect
    assert_redirected_to :action=> 'show'
    assert_equal num+1 , Compound.count
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
    assert_not_nil Compound.find(@item.id)
    post :destroy, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end
  
end
