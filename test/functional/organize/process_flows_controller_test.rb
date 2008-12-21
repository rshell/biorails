require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/organize/process_flows_controller"

# Re-raise errors caught by the controller.
class Organize::ProcessFlowsController; def rescue_action(e) raise e end; end

class Organize::ProcessFlowsControllerTest < Test::Unit::TestCase

  def setup
    @controller = Organize::ProcessFlowsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 2
    @request.session[:current_user_id] = 3
    @assay = Assay.find(:first)
    @item = ProcessFlow.find(10)
    @step = ProcessStep.find(1)
  end

  def test_index
    get :index, :id => @assay.id
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list, :id => @assay.id
    assert_response :success
    assert_template 'list'
    assert_not_nil assigns(:assay_protocols)
  end
  
  def test_list_without_id
    get :list
    assert_response :success
    assert_template 'list'
    assert_not_nil assigns(:assay_protocols)
  end

  def test_show
    get :show, :id => @item.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:assay_protocol)
    assert assigns(:assay_protocol).valid?
  end
  
  def test_modernize
    get :modernize, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

  def test_destroy
    get :destroy, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

  def test_show_invalid
    get :show, :id => 24242432
    assert_response :success
    assert_template  'access_denied'
  end

  def test_show_denied
    User.current = User.find(9)
    Project.current = Project.find(3)
    @request.session[:current_project_id] =Project.current.id
    @request.session[:current_user_id] = User.current.id
    assert_nil Project.current.member(User.current)
    assert_nil ProcessFlow.load(@item.id)
    get :show, :id => @item.id
    assert_response :success
    assert_template  'access_denied'
  end
    
  def list_show_denied
    @request.session[:current_project_id] =2
    @request.session[:current_user_id] = 9    
    get :list, :id => @assay.id
    assert_response :success
    assert_template  'access_denied'
  end
    
  def test_edit
    get :edit, :id => @item.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:assay_protocol)
    assert assigns(:assay_protocol).valid?
  end
  
  
  def test_release
    get :release, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:process_flow)
    assert assigns(:process_flow).valid?
  end

  def test_withdraw
    get :withdraw, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:process_flow)
    assert assigns(:process_flow).valid?
  end
  
  def test_copy
    get :copy, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:process_flow)
    assert assigns(:process_flow).valid?
  end
  
  def test_tree_root
    get :tree, :id => @item.id, :node=>'root'
    assert_response :success
  end
  
  def test_tree_assay
    get :tree, :id => @item.id, :node=>Assay.find(:first).dom_id
    assert_response :success
  end
 
  def test_tree_assay_protocol
    get :tree, :id => @item.id, :node=>AssayProtocol.find(:first).dom_id
    assert_response :success
  end
 
  def test_tree_project
    get :tree, :id => @item.id, :node=>Project.find(:first).dom_id
    assert_response :success
  end
 
  def test_tree_invalid
    get :tree, :id => @item.id, :node=>'errors'
    assert_response :success
  end

  def test_purge
    get :purge, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

  def test_new
    get :new, :id => @assay.id
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:assay_protocol)
  end

  def test_new_ajax
    get :new, :id => @assay.id,:format=>'js'
    assert_response :success
    assert_template '_new'
    assert_not_nil assigns(:assay_protocol)
    assert_not_nil assigns(:process_flow)
  end

  def test_create_ok
    num_assay_protocols = AssayProtocol.count
    post :create, :id => @assay.id, :assay_protocol => {:name=>'xxxssx',:description=>'sfsfs'}
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_equal num_assay_protocols+1, AssayProtocol.count
  end
  
  def test_create_failed
    num_assay_protocols = AssayProtocol.count
    sp=AssayProtocol.find(:first)
    post :create,:id => @assay.id, :assay_protocol=>{:name=>sp.name}
    assert_response :success 
    assert_equal num_assay_protocols, AssayProtocol.count
  end
  
  def test_update
    post :update, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

  def test_update_failed
    post :update, :id => @item.id,:assay_protocol=>{:name=>nil},:process_flow=>{:name=>nil}
    assert_response :success
    assert_template 'show'
  end

  def test_add_js
    post :add, :id => @item.id, :node=> ProcessInstance.find(:first).dom_id,:format=>'js'
    assert_response :success
    assert_template '_schedule'
  end

  def test_add_js
    post :add, :id => @item.id, :node=> ProcessInstance.find(:first).dom_id
    assert_response :success
    assert_template 'show'
  end

  def test_add_and_remove
    assay_protocol = AssayWorkflow.find(:first)
    flow   = assay_protocol.new_version
    num = flow.steps.size
    post :add, :id => flow.id, :node=> ProcessInstance.find(:first).dom_id
    assert_response :success
    assert_template 'show'
    flow.reload
    assert num+1,flow.steps.size
    step = flow.steps.last
    post :remove, :id => step.id
    assert_response :success
    assert_template 'show'    
    flow.reload
    assert num,flow.steps.size
  end

  def test_add_and_remove_ajax
    assay_protocol = AssayWorkflow.find(:first)
    flow   = assay_protocol.new_version
    num = flow.steps.size
    post :add, :id => flow.id, :node=> ProcessInstance.find(:first).dom_id,:format=>'js'
    assert_response :success
    assert_template '_schedule'
    flow.reload
    assert num+1,flow.steps.size
    step = flow.steps.last
    post :remove, :id => step.id,:format=>'js'
    assert_response :success
    assert_template '_schedule'    
    flow.reload
    assert num,flow.steps.size
  end

  def test_remove
    post :remove, :id => @step.id
    assert_response :success
    assert_template 'show'
  end

  def test_remove_js
    post :remove, :id => @step.id,:format=>'js'
    assert_response :success
    assert_template '_schedule'
  end
  
  def test_step
    post :step, :id => @step.id
    assert_response :success
    assert_template 'show'
  end
  
  def test_step_js
    post :step, :id => @step.id,:format=>'js'
    assert_response :success
    assert_template '_schedule'
  end
  
  def test_change_nothing
    post :change, :id => @step.id
    assert_response :success
    assert_template 'show'
  end
  
  def test_change_name
    post :change, :commit=>'Update',:id => @step.id,:process_step=>{:name=>'sssss'}
    assert_response :success
    assert_template 'show'
  end
  

  def test_change_js
    post :change, :id => @step.id, :commit=>'Update',:format=>'js'
    assert_response :success
    assert_template '_schedule'
  end
  
end
