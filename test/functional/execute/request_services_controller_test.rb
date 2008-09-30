require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/execute/request_services_controller"

class Execute::RequestServicesController; def rescue_action(e) raise e end; end

class Execute::RequestServicesControllerTest < Test::Unit::TestCase


  def setup
    @controller = Execute::RequestServicesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @first = RequestService.find(:first)
    @folder = ProjectFolder.find(:first)
    @request.session[:current_element_id] =@folder.id
    @request.session[:current_project_id] = @folder.project.id
    @request.session[:current_user_id] =3
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
    assert_not_nil assigns(:request_services)
  end

  def test_show
    get :show, :id => @first.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:request_service)
    assert assigns(:request_service).valid?
  end

  def test_show_invalid
    get :show, :id => 24242432
    assert_response :redirect
    assert_redirected_to :action => 'access_denied'
  end
  
  def test_edit
    get :edit, :id => @first.id
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:request_service)
    assert assigns(:request_service).valid?
  end

  def test_update
    post :update, :id => @first.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first.id
  end

  def test_update_failed
    post :update, :id => @first.id, :request_service=>{:name => nil}
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:request_service)
    assert !assigns(:request_service).valid?
  end

  def test_update_service
    post :update_service, :id => @first.id,:status_id=>1,:priority_id=>1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first.id
  end

  def test_update_service_js
    post :update_service, :id => @first.id,:status_id=>1,:priority_id=>1,:format=>'js'
    assert_response :success
  end

  def test_update_service_json
    post :update_service, :id => @first.id,:status_id=>1,:priority_id=>1,:format=>'json'
    assert_response :success
  end

  def test_update_service_xml
    post :update_service, :id => @first.id,:status_id=>1,:priority_id=>1,:format=>'xml'
    assert_response :success
  end


  def test_update_item
    @item =QueueItem.find(:first)
    post :update_item, :id => @item.id,:status_id=>1,:priority_id=>1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first.id
  end

  def test_update_item_js
    @item =QueueItem.find(:first)
    post :update_item, :id => @item.id,:status_id=>1,:priority_id=>1,:format=>'js'
    assert_response :success
  end

  def test_update_item_json
    @item =QueueItem.find(:first)
    post :update_item, :id => @item.id,:status_id=>1,:priority_id=>1,:format=>'json'
    assert_response :success
  end

  def test_update_item_xml
    @item =QueueItem.find(:first)
    post :update_item, :id => @item.id,:status_id=>1,:priority_id=>1,:format=>'xml'
    assert_response :success
  end

  def test_destroy_item
    @item =QueueItem.find(:first)
    post :destroy_item, :id => @item.request_service_id,:item_id=>@item.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @item.request_service_id
  end

  def test_destroy
    RequestService.transaction do
        assert_nothing_raised {
          RequestService.find(@first.id)
        }
        post :destroy, :id => @first.id
        assert_response :redirect
        assert_redirected_to :action =>'show'
        assert_raise(ActiveRecord::RecordNotFound) {
          RequestService.find(@first.id)
        }
     #raise ActiveRecord::Rollback 
    end  
  end
  
  
  def test_results
    get :results, :id => @first.id
    assert_response :success
    assert_template 'report'
    assert_not_nil assigns(:request_service)
    assert_not_nil assigns(:report)
    assert_not_nil assigns(:data)
    assert assigns(:request_service).valid?
  end
  
  
end

