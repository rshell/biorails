require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/admin/users_controller"

# Re-raise errors caught by the controller.
class Admin::UsersController; def rescue_action(e) raise e end; end

class Admin::UsersControllerTest < Test::Unit::TestCase

  def setup
    @controller = Admin::UsersController.new
    @request    = ActionController::TestRequest.new 
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @item = User.find(:first)
  end

  def test001_setup
    assert_not_nil @controller
    assert_not_nil @response
    assert_not_nil @request
    assert_not_nil @item
  end
  
  def test002_index
    get :index
    assert_response :success
  end
  
  def test003_new
    get :new,nil,@session
    assert_response :success
  end

  def test004_create
    post :create, :user => {:name =>'poweruser',:password =>'test3', :login =>'poweruser', :role_id => 7}
    assert_response :redirect
    assert_ok(assigns(:user))
  end
  
  def test005_create_invalid_user
    @params = {:user => {:name =>nil,:password =>'test3', :role_id => 1}}
    post :create, @params, @session
    assert_not_nil assigns(:user)
    assert !assigns(:user).valid?
    assert assigns(:user).errors
    assert assigns(:user).errors[:login]
    assert_response :success
  end

  def test006_create_no_password
    @params = {:user => {:name =>nil,:password =>'', :role_id => 1}}
    post :create, @params, @session
    assert_not_nil assigns(:user)
    assert !assigns(:user).valid?
    assert assigns(:user).errors
    assert assigns(:user).errors[:login]
    assert_response :success
  end

  
  def test007_edit
    get :edit,:id=>@item.id
    assert_response :success
  end

  def test008_update
    @params = {:id=>@item.id,:user => {:name =>'test3',:password =>'test3', :login =>'test3', :role_id => 1}}
    post :update,  @params, @session
    assert_response :redirect
    assert_ok(assigns(:user))
  end  

  def test009_update_fail
    @params = {:id=>@item.id,:user => {:name =>nil,:password =>'', :login =>nil, :role_id => 1}}
    post :update,  @params, @session
    assert_response :success
    assert !assigns(:user).valid? 
  end  

  def test010_show
    get :show,:id=>3
    assert_response :success
  end

  def test011_ldap
    get :ldap,:id=>'a'
    assert_response :success
  end


  def test009_choices
    get :choices,:query=>'r'
    assert_response :success
  end

  
end
