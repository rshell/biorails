require File.dirname(__FILE__) + '/../test_helper'
require 'auth_controller'

# Re-raise errors caught by the controller.
class AuthController; def rescue_action(e) raise e end; end

class AuthControllerTest < BiorailsTestCase
  def setup
    @controller = AuthController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = nil
    @request.session[:current_user_id] = nil
  end
  
  def test_login_show
     get :login
     assert_response :success
   end

  def test_index
     get :index
     assert_response :success
   end

    def test_login_exception
    @controller.send(:login)
    flunk("should throw exception")
  rescue    
  end
  
  def test_login_failed1  
    assert_nothing_raised {post :login, {:login=>'', :password=>'', :method_missing=>''}}
  end
  
  def test_login_ok
    @request.session[:current_project_id]=2
    post :login,{:login=>'rshell',:password=>'y90125'}    
    assert_response :redirect
    assert User.current
    assert Project.current.id
  end
  
  def test_login_when_session_invalid
   @request.session[:current_user_id]=10000000
   @request.session[:current_project_id]=nil 
    post :login,{:login=>'rshell',:password=>'y90125'}   
    assert flash[:warning] 
    assert_match /Invalid session information/, flash[:warning]
    assert Project.current.id
    assert ProjectFolder.current.id
  end
  
  def test_login_when_session_invalid_and_folder_invalid
    @request.session[:current_folder_id]=1000000
    @request.session[:current_user_id]=10000000
    post :login,{:login=>'rshell',:password=>'y90125'}   
    assert flash[:warning] 
    assert_match /Invalid session information/, flash[:warning]
    assert ProjectFolder.current.id
  end

  def test_login_nil_user
    @request.session[:current_project_id]=2
    post :login,{:login=>nil,:password=>'y90125'}    
    assert_response :success
    assert_template 'forgotten'
  end 

  def test_login_nil
    post :login
    assert_response :success
    assert_template 'forgotten'
  end
  
  def test_login_no_password
    post :login,{:login=>'rshell',:password=>''}    
    assert_response :success
    assert_template 'forgotten'
  end
  
  def test_login_no_user
    post :login,{:login=>'',:password=>'y90125'}    
    assert_response :success
    assert_template 'forgotten'
  end
    
  def test_logout
    get :logout
    assert_response :success
  end

  def test_login_bad_session_project
    @request.session[:current_project_id] = 43232
    get :login
    assert_response :success
    assert_template 'login'
  end
  
  def test_login_bad_session_user
    @request.session[:current_user_id] = 232    
    get :login
    assert_response :success
    assert_template 'forgotten'
  end
  
  def test_login_bad_session_user
    @request.session[:current_folder_id] = 232    
    get :login
    assert_response :success
    assert_template 'login'
  end
  
end
