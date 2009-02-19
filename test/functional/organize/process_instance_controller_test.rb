require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/organize/process_instances_controller"

# Re-raise errors caught by the controller.
class Organize::ProcessInstancesController; def rescue_action(e) raise e end; end

class Organize::ProcessInstancesControllerTest < BiorailsTestCase

  def setup
    @controller = Organize::ProcessInstancesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 2
    @request.session[:current_user_id] = 3
    @assay = Assay.find(:first)
    @item = ProcessInstance.find(1)
    @unused_item = ProcessInstance.find(4)
    @parameter_context =  ParameterContext.find(1)
    @assay_parameter = AssayParameter.find(1)
    @assay_queue = AssayQueue.find(1)
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

  def test_show
    get :show, :id => @item.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:assay_protocol)
    assert assigns(:assay_protocol).valid?
  end

  def test_show
    get :format, :id => @item.id
    assert_response :success
    assert_template 'format'
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
    assert_nil ProcessInstance.load(@item.id) 
    get :show, :id => @item.id
    assert_response :success
    assert_template  'access_denied'
  end
    
  def test_show_js
    get :show, :id => @item.id,:format=>'js'
    assert_response :success
    assert_not_nil assigns(:assay_protocol)
    assert assigns(:assay_protocol).valid?
  end

  def test_release
    get :release, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:protocol_version)
    assert assigns(:protocol_version).valid?
  end

  def test_withdraw
    get :withdraw, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:protocol_version)
    assert assigns(:protocol_version).valid?
  end

  def test_copy
    get :copy, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:protocol_version)
    assert assigns(:protocol_version).valid?
  end

  def test_metrics
    get :metrics, :id => @item.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:assay_protocol)
    assert assigns(:assay_protocol).valid?
  end
  
  def test_layout
    get :layout, :id => @item.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:assay_protocol)
    assert_not_nil assigns(:protocol_version)
    assert assigns(:assay_protocol).valid?
    assert assigns(:protocol_version).valid?
  end

  def test_layout_js
    get :layout, :id => @item.id,:format=>'js'
    assert_response :success
    assert_not_nil assigns(:assay_protocol)
    assert_not_nil assigns(:protocol_version)
    assert assigns(:assay_protocol).valid?
    assert assigns(:protocol_version).valid?
  end

  def test_purge
    get :purge, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end
  
  def test_destroy_used_failed
    assert @item.used?
    post :destroy, :id => @item.id
    assert flash[:warning]
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end
  
  def test_destroy_not_used
    post :destroy, :id =>@unused_item.id
    assert_nil flash[:warning],flash[:warning]
    assert_nil flash[:error],flash[:error]
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end
  
  def test_context
    get :context, :id => ParameterContext.find(:first).id
    assert_response :success
    assert_not_nil assigns(:parameter_context)
  end
 
  def test_new
    get :new, :id => @assay.id
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:assay_protocol)
  end

  def test_new
    get :new, :id => @assay.id
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:assay_protocol)
  end

  def test_new_xml
    get :new, :id => @assay.id,:format=>'xml'
    assert_response :success
    assert_not_nil assigns(:assay_protocol)
  end
  
  def test_create_ok
    num_assay_protocols = AssayProtocol.count
    post :create, :id => @assay.id, :assay_protocol => {:name=>'xxxx',:description=>'xxxxxx'}
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_equal num_assay_protocols+1, AssayProtocol.count
  end

  def test_create_invalid_with_duplicate_name
    num_assay_protocols = AssayProtocol.count
    post :create, :id => @assay.id, :assay_protocol => {:name=>AssayProtocol.find(:first).name}
    assert_response :success
    assert_template 'new'
    assert_equal num_assay_protocols, AssayProtocol.count
  end
  
  def test_update_failed
    post :update, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end
  
  def test_update_ok
    post :update, :id => @item.id,:assay_protocol=>{},:protocol_version=>{}
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end
  
  def test_update_makes_invalid_with_duplicate_name
    post :update, :id => @assay.id, :assay_protocol => {:name=>AssayProtocol.find(2).name}
    assert_response :redirect
    assert_redirected_to :action=>'show'
  end

  def test_update_fixed_context
    assert !@item.flexible?
    get :update_context, :id => @parameter_context.id,:label=>'xxx',:default_count=>'4'
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:parameter_context)
  end
 
  def test_update_fixed_context_js
    assert !@item.flexible?
    get :update_context, :id => @parameter_context.id,:label=>'xxx',:default_count=>'4',:output_style=>'default',:format=>'js'
    assert_response :success
    assert_not_nil assigns(:parameter_context)
  end
 
  def test_update_context
    assert @unused_item.flexible?
    get :update_context, :id => @unused_item.contexts[0].id,:label=>'xxx',:output_style=>'default', :default_count=>'4'
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:parameter_context)
  end
 
  def test_update_context_valid
    assert @unused_item.flexible?
    get :update_context, :id => @unused_item.contexts[0].id,:label=>nil,:default_count=>'4'
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:parameter_context)
  end
 
  def test_update_context_js
    assert @unused_item.flexible?
    get :update_context, :id => @unused_item.contexts[0].id,:label=>'xxx',:output_style=>'default', :default_count=>'4',:format=>'js'
    assert_response :success
    assert_not_nil assigns(:parameter_context)
  end
 
  def test_add_context
    get :add_context, :id => @parameter_context.id,:label=>'xxx2',:default_count=>'4',:output_style=>'default'
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:parameter_context)
  end
 
  def test_add_context_js
    get :add_context, :id => @parameter_context.id,:label=>'xxx2',:default_count=>'4',:format=>'js',:output_style=>'default'
    assert_response :success
    assert_not_nil assigns(:parameter_context)
  end
 
  def test_remove_fixed_context
    get :remove_context, :id => @parameter_context.id
    assert_response :redirect
    assert !flash[:info],flash[:info]
    assert flash[:error]
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:parameter_context)
  end

  def test_remove_root_context
    context = @unused_item.roots[0]
    get :remove_context, :id => context
    assert_response :redirect
    assert flash[:error],flash[:error]
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:parameter_context)
  end
  
  def test_remove_leaf_context
    context = @unused_item.contexts.last
    assert context.process.changeable?
    get :remove_context, :id => context
    assert_response :redirect
    assert_nil flash[:error],flash[:error]
    assert_nil flash[:warning]
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:parameter_context)
  end
  
  def test_remove_fixed_context_js
    get :remove_context, :id => @parameter_context.id,:format=>'js'
    assert_response :success
    assert_not_nil assigns(:parameter_context)
  end
 
  def test_add_parameter
    get :add_parameter, :id => @parameter_context.id, :node => "sp_#{@assay_parameter.dom_id}"
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:parameter_context)
  end

  def test_add_parameter_js
    get :add_parameter, :id => @parameter_context.id, :node => "sp_#{@assay_parameter.dom_id}",:format=>'js'
    assert_response :success
    assert_not_nil assigns(:parameter_context)
  end

  def test_add_parameter_xml
    get :add_parameter, :id => @parameter_context.id, :node => "sp_#{@assay_parameter.dom_id}",:format=>'xml'
    assert_response :success
    assert_not_nil assigns(:parameter_context)
  end

  def test_add_parameter_from_queue
    get :add_parameter, :id => @parameter_context.id, :node => "sq_#{@assay_queue.id}"
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:parameter_context)
  end
  
  def test_add_parameter_from_queue_xml
    get :add_parameter, :id => @parameter_context.id, :node => "sq_#{@assay_queue.id}",:format=>'xml'
    assert_response :success
    assert_not_nil assigns(:parameter_context)
  end
  
  def test_add_parameter_from_queue_js
    get :add_parameter, :id => @parameter_context.id, :node => "sq_#{@assay_queue.id}",:format=>'js'
    assert_response :success
    assert_not_nil assigns(:parameter_context)
  end
  
  def test_remove_parameter
    parameter = Parameter.find(1)
    get :remove_parameter, :id => parameter.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:parameter_context)
  end
  
  def test_remove_parameter_js
    parameter = Parameter.find(1)
    get :remove_parameter, :id => parameter.id,:format=>'js'
    assert_response :success
    assert_not_nil assigns(:parameter_context)
  end
  
  def test_remove_parameter_xml
    parameter = Parameter.find(1)
    get :remove_parameter, :id => parameter.id,:format=>'xml'
    assert_response :success
    assert_not_nil assigns(:parameter_context)
  end
  
  def test_move_parameter_js
    parameter1 = Parameter.find(3)
    parameter2 = Parameter.find(5)
    get :move_parameter, :id => parameter1.id,:after=>parameter2.id,:format=>'js'
    assert_response :success
    assert_not_nil assigns(:parameter_context)
  end
  
  def test_move_parameter
    parameter1 = Parameter.find(3)
    parameter2 = Parameter.find(5)
    get :move_parameter, :id => parameter1.id,:after=>parameter2.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:parameter_context)
  end

  def test_create_fill_protocol
    post :create, :id => @assay.id, :assay_protocol => {:name=>'xxxx',:description=>'xxxxxx'}
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:protocol_version)
    new_version = assigns(:protocol_version)
    assert new_version.valid?    
    
    post :add_context,:id=>new_version.contexts[0].id,:label=>'xxx',:default_count=>3
    assert_response :redirect
    assert_redirected_to :action => 'show'
    new_context = assigns(:parameter_context)
    assert new_context.valid?    
    sp1 = @assay.parameters[0]
    
    post :add_parameter,:id=>new_context.id,:node=>"sp_#{sp1.id}",:lock_version=>new_context.lock_version
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:parameter)   
    new_parameter = assigns(:parameter)   
    assert new_parameter.valid?    
    
    post :update_parameter ,:id=>new_parameter.id,:field=>'name',:value=>'xxxxx_3'
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:parameter)   
    new_parameter = assigns(:parameter)   
    assert new_parameter.valid?    
  end

  def test_create_fill_protocol_js
    post :create, :id => @assay.id, :assay_protocol => {:name=>'xxxx',:description=>'xxxxxx'}
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:protocol_version)
    new_version = assigns(:protocol_version)
    assert new_version.valid?    
    
    post :add_context,:id=>new_version.contexts[0].id,:label=>'xxx',:default_count=>3,:format=>'js'
    assert_response :success
    assert !flash[:error],flash[:error]
    assert !flash[:warning],flash[:warning]
    assert assigns(:successful)
    new_context = assigns(:parameter_context)
    assert new_context.valid?    
    sp1 = @assay.parameters[0]
    
    post :add_parameter,:id=>new_context.id,:node=>"sp_#{sp1.id}",:lock_version=>new_context.lock_version,:format=>'js'
    assert_response :success
    assert assigns(:successful)
    assert_not_nil assigns(:parameter)   
    new_parameter = assigns(:parameter)   
    assert new_parameter.valid?    
    
    post :update_parameter ,:id=>new_parameter.id,:field=>'name',:value=>'xxxxx_3',:format=>'js'
    assert_response :success
    assert_not_nil assigns(:parameter)   
    new_parameter = assigns(:parameter)   
    assert new_parameter.valid?    
  end

 
end
