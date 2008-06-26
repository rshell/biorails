require File.dirname(__FILE__) + '/../../test_helper'
require  "#{RAILS_ROOT}/app/controllers/organize/assay_queues_controller"

# Re-raise errors caught by the controller.
class Organize::AssayQueuesController; def rescue_action(e) raise e end; end

class Organize::AssayQueuesControllerTest < Test::Unit::TestCase
  # fixtures :assay_queues

  def setup
    @controller = Organize::AssayQueuesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 2
    @request.session[:current_user_id] = 3
    @assay = Assay.find(:first)
    @item = AssayQueue.find(:first)
 end

  def test_index
    get :index,:id=> @assay.id
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list,:id=> @assay.id
    assert_response :success
    assert_template 'list'
    assert_not_nil assigns(:assay_queues)
  end

  def test_list_for_current_project
    get :list
    assert_response :success
    assert_template 'list'
    assert_not_nil assigns(:assay_queues)
  end

  def test_show
    get :show, :id => @item.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:assay_queue)
    assert assigns(:assay_queue).valid?
  end

  def test_show_invalid
    get :show, :id => 24242432
    assert_response :redirect
    assert_redirected_to :action => 'access_denied'
  end

  def test_show_denied
    @request.session[:current_project_id] =1
    @request.session[:current_user_id] = 1    
    get :show, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'access_denied'
  end
  
  def test_new
    get :new, :id => @item.id
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:assay_queue)
  end

  def test_new_failed
    get :new
    assert_response :redirect
  end

  def test_manage
    get :manage, :id => @item.id
    assert_response :success
    assert_template 'manage'
    assert_not_nil assigns(:assay_queue)
  end

  def test_results
    get :results, :id => @item.id
    assert_response :success
    assert_template 'report'
    assert_not_nil assigns(:assay_queue)
    assert_not_nil assigns(:report)
    assert_not_nil assigns(:data)
  end

  def test_results_failed
    get :results
    assert_response :redirect
  end

  def test_create_invalid
    num_assay_queues = AssayQueue.count
    post :create, :id => @item.id, :assay_queue => {}
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:assay_queue)
    assert !assigns(:assay_queue).valid? 
    assert assigns(:assay_queue).errors
    assert assigns(:assay_queue).errors[:name]
    assert_equal num_assay_queues , AssayQueue.count
  end
  
  def test_create_valid_queue
    num_assay_queues = AssayQueue.count
    post :create, :id => @item.id, :assay_queue=>{:assay_stage_id=>5 , :name=>"new q", :assigned_to_user_id=>3, :description=>"a new q with a description", :assay_parameter_id=>24}
    assert_redirected_to :action=>'list'
    assert flash[:notice]
    assert_equal num_assay_queues +1 , AssayQueue.count
  end

  def test_edit
    get :edit, :id => @item.id
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:assay_queue)
    assert assigns(:assay_queue).valid?
  end

  def test_update_ok
    post :update, :id => @item.id ,:assay_queue=>{:name=>'xxx'}
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end
  
  def test_update_with_invalid_data
    post :update, :id => @item.id ,:assay_queue=>{:name=>''}
    assert_response :success
    assert_not_nil assigns(:assay_queue)
    assert !assigns(:assay_queue).valid? 
    assert assigns(:assay_queue).errors
    assert assigns(:assay_queue).errors[:name]
    assert_empty_error_field('assay_queue[name]')
    assert_select 'li', "Name can't be blank"
  end


  def test_destroy
    assert_not_nil AssayQueue.find(@item.id)
    post :destroy, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list'
    assert_raise(ActiveRecord::RecordNotFound) {
      AssayQueue.find(@item.id)
    }
  end
  
  def test_update_service
    req = RequestService.find(:first)
    get :update_service, :id => req.id
    assert_response :success
    assert_template 'show'
  end
  
  def test_update_service_js
    req = RequestService.find(:first)
    get :update_service, :id => req.id,:format=>'js'
    assert_response :success
    assert_template '_request_service'
  end
  
  def test_update_item_status
    qi = QueueItem.find(:first)
    get :update_item, :id => qi.id,:status_id=>3
    assert_response :success
    assert_template '_queue_item'
  end
   
  def test_update_item_priority
    qi = QueueItem.find(:first)
    get :update_item, :id => qi.id,:priority_id=>1
    assert_response :success
    assert_template '_queue_item'
  end
   
  def test_update_item_comments
    qi = QueueItem.find(:first)
    get :update_item, :id => qi.id,:comments=>'xxx'
    assert_response :success
    assert_template '_queue_item'
  end
   
end
