require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/execute/requests_controller"

# Re-raise errors caught by the controller.
class Execute::RequestsController; def rescue_action(e) raise e end; end

class Execute::RequestsControllerTest < Test::Unit::TestCase

  def setup
    @controller = Execute::RequestsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @first = Request.find(:first)
    @request.session[:current_element_id] =@first.project_element_id
    @request.session[:current_project_id] = @first.project_id
    @request.session[:current_user_id] = 3
  end

  def test_setup
    assert_not_nil @controller
    assert_not_nil @request
    assert_not_nil @response
    assert_not_nil @first , "Missing a valid fixture for this controller"
    assert_not_nil @first.id
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
    assert_not_nil assigns(:report)
  end

  def test_show
    get :show, :id => @first.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:user_request)
    assert assigns(:user_request).valid?
  end
  
  def test_show_invalid
    get :show, :id => 24242432
    assert_response :success
    assert_template  'access_denied'
  end

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:user_request)
  end

  def test_create_invalid
    num_requests = Request.count
    post :create, :user_request => {}
    assert_response :success
    assert_template 'new'
    assert_equal num_requests , Request.count
  end

  def test_create_ok
    num = Request.count
    post :create, :user_request => {:name=>'xxxx',:expected_at=>'2020-12-1',:description=>'sssss',:data_element_id=>1,:project_id=>2}
    assert_response :redirect
    assert_equal num+1 , Request.count
  end

  def test_edit
    get :edit, :id => @first.id
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:user_request)
    assert assigns(:user_request).valid?
  end

  def test_update
    post :update, :id => @first.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first.id
  end

  def test_update_failed
    post :update, :id => @first.id,:user_request=>{:name=>nil}
    assert_response :success
    assert_template 'edit'
  end

  def test_destroy
    Request.transaction do
        assert_nothing_raised {
          Request.find(@first.id)
        }
        post :destroy, :id => @first.id
        assert_response :redirect
        assert_redirected_to :action =>'list'
        assert_raise(ActiveRecord::RecordNotFound) {
          Request.find(@first.id)
        }
     #raise ActiveRecord::Rollback 
    end  
  end
  
  def test_results
    get :results, :id => @first.id
    assert_response :success
    assert_template 'report'
    assert_not_nil assigns(:user_request)
    assert_not_nil assigns(:report)
  end

  def test_add_item
    get :add_item, :id => @first.id,:value=>'ESC32165'
    assert_response :redirect
  end

  def test_add_item_ajax
    get :add_item, :id => @first.id,:value=>'ESC32165',:format=>'js'
    assert_response :success
  end

  def test_remove_item
    item = ListItem.find(3)
    get :remove_item, :id => item.id,:request_id=>1
    assert_response :redirect
  end

  def test_remove_item_ajax
    item = ListItem.find(3)
    get :remove_item, :id => item.id,:request_id=>1,:format=>'js'
    assert_response :success
  end

  def test_add_service
    queue = AssayQueue.find(2)
    get :add_service, :id => @first.id ,:service=>{:id=>queue.id}
    assert_response :redirect
    assert_not_nil assigns(:user_request)
    assert assigns(:user_request).valid?
  end

  def test_add_service_ajax
    queue = AssayQueue.find(2)
    get :add_service, :id => @first.id ,:service=>{:id=>queue.id},:format=>'js'
    assert_response :success
    assert_not_nil assigns(:user_request)
    assert assigns(:user_request).valid?
  end

  def test_remove_service
    get :remove_service, :id => @first.id
    assert_response :redirect
    assert_not_nil assigns(:user_request)
    assert assigns(:user_request).valid?
  end

  def test_remove_service_ajax
    get :remove_service, :id => @first.id,:format=>'js'
    assert_response :success
    assert_not_nil assigns(:user_request)
    assert assigns(:user_request).valid?
  end

  
end

