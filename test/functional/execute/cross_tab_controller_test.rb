require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/execute/cross_tab_controller"

# Re-raise errors caught by the controller.
class Execute::CrossTabController; def rescue_action(e) raise e end; end

class Execute::CrossTabControllerTest < Test::Unit::TestCase

  def setup
    @controller = Execute::CrossTabController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @cross_tab = CrossTab.find(:first)
    @project = @cross_tab.project
    @request.session[:current_element_id] =@cross_tab.project_element_id
    @request.session[:current_project_id] = @cross_tab.project.id
    @request.session[:current_user_id] = 3
  end

  def test00_setup
    assert_not_nil @controller
    assert_not_nil @request
    assert_not_nil @response
    assert_not_nil @cross_tab , "Missing a valid fixture for this controller"
    assert_not_nil @cross_tab.id
  end

  def test01_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test02_list
    get :list
    assert_response :success
    assert_not_nil assigns(:cross_tabs)
  end

  def test03_show
    get :show, :id => @cross_tab.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:cross_tab)
    assert assigns(:cross_tab).valid?
  end

  def test03_show_invalid_id
    get :show, :id => 329593593295
    assert_response :success
    assert_template 'access_denied'
  end

    def test13_show_js
    get :show, :id => @cross_tab.id,:format=>'js'
    assert_response :success
    assert_template '_show'
    assert_not_nil assigns(:cross_tab)
    assert assigns(:cross_tab).valid?
  end

    def test14_show_xml
    get :show, :id => @cross_tab.id,:format=>'xml'
    assert_response :success
    assert_not_nil assigns(:cross_tab)
    assert assigns(:cross_tab).valid?
  end

  def test04_new
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:cross_tab)
  end

  def test05_create_ok
    num_request_services = CrossTab.count
    post :create, :cross_tab => {:name=>'test05',:description=>'test05'}
    assert_response :redirect
    assert_not_nil assigns(:cross_tab)
    assert assigns(:cross_tab).valid?
    assert_equal num_request_services+1 , CrossTab.count
  end

  def test06_create_failed
    num_request_services = CrossTab.count
    post :create, :cross_tab => {:description=>'test05'}
    assert_response :success
    assert_template 'new'
    assert_equal num_request_services , CrossTab.count
  end
  
  def test07_edit
    get :edit, :id => @cross_tab.id
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:cross_tab)
    assert assigns(:cross_tab).valid?
  end

  def test08_update_ok
    post :update, :id => @cross_tab.id, :cross_tab => {:name=> @cross_tab.name, :description=>'test05'}
    assert_response :redirect
    assert_not_nil assigns(:cross_tab)
    assert assigns(:cross_tab).valid?
  end

  def test08_update_ok_js
    post :update, :id => @cross_tab.id,:format=>'js', :cross_tab => {:name=> @cross_tab.name, :description=>'test05'}
    assert_response :success
    assert_not_nil assigns(:cross_tab)
    assert assigns(:cross_tab).valid?
  end

  def test09_update_fail
    post :update, :id => @cross_tab.id, :cross_tab => {:name=>'test', :description=>''}
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:cross_tab)
    assert !assigns(:cross_tab).valid?
     assert_empty_error_field('cross_tab[description]')
  end
 
  def test10_destroy
      assert_nothing_raised {
        CrossTab.find(@cross_tab.id)
      }

      post :destroy, :id => @cross_tab.id
      assert_response :redirect
      assert_redirected_to :action =>'index'

      assert_raise(ActiveRecord::RecordNotFound) {
        CrossTab.find(@cross_tab.id)
      }
  end

  def test11_print
    get :print, :id => @cross_tab.id
    assert_response :success
    assert_template 'print'
    assert_not_nil assigns(:cross_tab)
    assert assigns(:cross_tab).valid?
  end

  def test11_print_pdf
    get :print, :id => @cross_tab.id,:format=>'pdf'
    assert_response :success
    assert_template 'print'
    assert_not_nil assigns(:cross_tab)
    assert assigns(:cross_tab).valid?
  end

  def test11_print_xml
    get :print, :id => @cross_tab.id,:format=>'xml'
    assert_response :success
    assert_not_nil assigns(:cross_tab)
    assert assigns(:cross_tab).valid?
  end

  def test11_print_csv
    get :print, :id => @cross_tab.id,:format=>'csv'
    assert_response :success
    assert_not_nil assigns(:cross_tab)
    assert assigns(:cross_tab).valid?
  end

  def test12_export
    get :export, :id => @cross_tab.id
    assert_response :success
    assert assigns(:cross_tab_columns)
    assert assigns(:cross_tab_columns).is_a?(Array)
    assert assigns(:cross_tab_results)    
    assert assigns(:cross_tab_results).is_a?(Array)
  end

  def test13_export_with_results
    p = TaskValue.find(:first).parameter
    c = CrossTab.find(:first)
    post :add, :id => c.id,:node=>p.dom_id,:scope=>p.context.dom_id
    assert_response :success    
    get :export,:id => c.id,:page=>1
    assert assigns(:cross_tab_columns)
    assert assigns(:cross_tab_columns).is_a?(Array)
    assert assigns(:cross_tab_columns).size>0   
    assert assigns(:cross_tab_results)    
    assert assigns(:cross_tab_results).is_a?(Array)
    assert assigns(:cross_tab_results).size>0   
  end
  
  
  def test_tree_live_processes
    post :tree, :id => 1,:node=>:process
    assert_response :success
    assert_not_nil assigns(:items)
    assert assigns(:items).is_a?(Array)
  end

  def test_tree_live_parameters
    post :tree, :id => 1,:node=>'parameters'
    assert_response :success
    assert_not_nil assigns(:items)
    assert assigns(:items).is_a?(Array)
  end

  def test_tree_root_assays
    post :tree, :id => 1,:node=>'assays'
    assert_response :success
    assert_not_nil assigns(:items)
    assert assigns(:items).is_a?(Array)
  end

  def test_tree_root_protocols
    post :tree, :id => 1,:node=>'protocols'
    assert_response :success
    assert_not_nil assigns(:items)
    assert assigns(:items).is_a?(Array)
  end

  def test_tree_root_types
    post :tree, :id => 1,:node=>'types'
    assert_response :success
    assert_not_nil assigns(:items)
    assert assigns(:items).is_a?(Array)
  end

  def test_tree_root_roles
    post :tree, :id => 1,:node=>'roles'
    assert_response :success
    assert_not_nil assigns(:items)
    assert assigns(:items).is_a?(Array)
  end

 def test_tree_for_assay
    assay = Assay.find(:first)
    post :tree, :id => 1,:node=>assay.dom_id
    assert_response :success
    assert_not_nil assigns(:items)
    assert assigns(:items).is_a?(Array)
  end

  def test_tree_for_assay_parameter
    item = AssayParameter.find(:first)
    post :tree, :id => 1,:node=>item.dom_id
    assert_response :success
    assert_not_nil assigns(:items)
    assert assigns(:items).is_a?(Array)
  end

  def test_tree_for_assay_protocol
    item = AssayProtocol.find(:first)
    post :tree, :id => 1,:node=>item.dom_id
    assert_response :success
    assert_not_nil assigns(:items)
    assert assigns(:items).is_a?(Array)
  end

  def test_tree_for_protocol_version
    item = ProcessInstance.find(:first)
    post :tree, :id => 1,:node=>item.dom_id
    assert_response :success
    assert_not_nil assigns(:items)
    assert assigns(:items).is_a?(Array)
  end

  def test_tree_for_parameter_context
    item = ParameterContext.find(:first)
    post :tree, :id => 1,:node=>item.dom_id
    assert_response :success
    assert_not_nil assigns(:items)
    assert assigns(:items).is_a?(Array)
  end

  def test_tree_for_parameter_context_using_type
    item = ParameterContext.find(:first)
    scope = item.parameters[0].type
    post :tree, :id => 1,:node=>item.dom_id,:scope=>scope.dom_id
    assert_response :success
    assert_not_nil assigns(:items)
    assert assigns(:items).is_a?(Array)
  end
  
  def test_tree_for_parameter_context_using_type
    item = ParameterContext.find(:first)
    scope = item.parameters[0].type
    post :tree, :id => 1,:node=>item.dom_id,:scope=>scope.dom_id
    assert_response :success
    assert_not_nil assigns(:items)
    assert assigns(:items).is_a?(Array)
  end
  
  def test_tree_for_parameter_context_using_type
    item = ParameterContext.find(:first)
    scope = item.parameters[0].type
    post :tree, :id => 1,:node=>item.dom_id,:scope=>scope.dom_id
    assert_response :success
    assert_not_nil assigns(:items)
    assert assigns(:items).is_a?(Array)
  end
  
  def test_tree_for_parameter_context_using_role
    item = ParameterContext.find(:first)
    scope = item.parameters[0].role
    post :tree, :id => 1,:node=>item.dom_id,:scope=>scope.dom_id
    assert_response :success
    assert_not_nil assigns(:items)
    assert assigns(:items).is_a?(Array)
  end
  
  def test_tree_for_parameter_context_using_assay_parameter
    item = ParameterContext.find(:first)
    scope = item.parameters[0].assay_parameter
    post :tree, :id => 1,:node=>item.dom_id,:scope=>scope.dom_id
    assert_response :success
    assert_not_nil assigns(:items)
    assert assigns(:items).is_a?(Array)
  end
  
  def test_tree_for_type_using_role
    p = Parameter.find(:first)
    scope = p.role
    item = p.type
    post :tree, :id => 1,:node=>item.dom_id,:scope=>scope.dom_id
    assert_response :success
    assert_not_nil assigns(:items)
    assert assigns(:items).is_a?(Array)
  end

  def test_tree_for_process_using_type
    p = Parameter.find(:first)
    scope = p.type
    item = p.process
    post :tree, :id => 1,:node=>item.dom_id,:scope=>scope.dom_id
    assert_response :success
    assert_not_nil assigns(:items)
    assert assigns(:items).is_a?(Array)
  end
  
  def test_tree_for_process_using_type
    p = Parameter.find(:first)
    scope = p.type
    item = p.process
    post :tree, :id => 1,:node=>item.dom_id,:scope=>scope.dom_id
    assert_response :success
    assert_not_nil assigns(:items)
    assert assigns(:items).is_a?(Array)
  end
  
  def test_tree_with_exception
    post :tree, :id => 1,:node=>nil,:scope=>'xxx_23323'
    assert_response :success
  end
  
  def test_add_item_parameter
    p = Parameter.find(:first)
    c = CrossTab.find(:first)
    post :add, :id => c.id,:node=>p.dom_id,:scope=>p.context.dom_id
    assert_response :success    
  end
  
  def test_add_item_context
    p = ParameterContext.find(:first)
    c = CrossTab.find(:first)
    post :add, :id => c.id,:node=>p.dom_id,:scope=>p.process.dom_id
    assert_response :success    
  end

  def test_add_item_process_twice
    p = ProcessInstance.find(:first)
    c = CrossTab.find(:first)
    post :add, :id => c.id,:node=>p.dom_id
    assert_response :success    
    post :add, :id => c.id,:node=>p.dom_id
    assert_response :success    
  end

  def test_tree_error
    post :tree, :id => 1,:node=>'sfsfs_fdsfs',:scope=>'sfsas_2222'
    assert_response :success     
  end
  
  def test_remove
    p = Parameter.find(:first)
    c = CrossTab.find(:first)
    post :add, :id => c.id,:node=>p.dom_id,:scope=>p.context.dom_id
    assert_response :success  
    c = CrossTab.find(c.id)
    assert c.columns
    assert c.columns[0]    
    i = c.columns.size
    post :remove, :id => c.id,:column=>c.columns[0].id
    assert_response :redirect
    c = CrossTab.find(c.id)
    assert_equal c.columns.size,i-1   
  end

  def test_remove_ajax
    p = Parameter.find(:first)
    c = CrossTab.find(:first)
    post :add, :id => c.id,:node=>p.dom_id,:scope=>p.context.dom_id
    assert_response :success  
    c = CrossTab.find(c.id)
    assert c.columns
    assert c.columns[0]    
    i = c.columns.size
    post :remove, :id => c.id,:column=>c.columns[0].id,:format=>'js'
    assert_response :success  
    c = CrossTab.find(c.id)
    assert_equal c.columns.size,i-1   
  end

  def test_snapshot
    get :snapshot, :id => @cross_tab.id, :folder_id => @project.home.id,:name=>'ddddd',:title=>'tgtgdstdst'
    assert_response :redirect
    assert_not_nil assigns(:cross_tab)
    assert assigns(:cross_tab).valid?
  end
  
  
end
