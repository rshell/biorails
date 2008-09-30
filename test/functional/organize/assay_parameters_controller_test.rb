require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/organize/assay_parameters_controller"

# Re-raise errors caught by the controller.
class Organize::AssayParametersController; def rescue_action(e) raise e end; end

class Organize::AssayParametersControllerTest < Test::Unit::TestCase

  def setup
    @controller = Organize::AssayParametersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    Project.current = @project = Project.find(2)
    User.current = @user = User.find(3)
    @assay = Assay.find(:first)
    @parameter_type1 = ParameterType.find(:first)
    @parameter_type_alias = ParameterTypeAlias.find(:first)
    @parameter_type2 = @parameter_type_alias.type
    @item = @assay.parameters[0]
    @request.session[:current_element_id] =@assay.project_element_id
    @request.session[:current_project_id] = @assay.project_id
    @request.session[:current_user_id] = 3  
    
  end

  def test_setup
    assert_not_nil @controller
    assert_not_nil @request
    assert_not_nil @response
    assert_not_nil @project
    assert_not_nil @user
    assert_not_nil @assay
    assert_not_nil @item
    assert_not_nil @item.id
  end
  
  def test_index
    get :index,:id=>@assay.id
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list,:id=>@assay.id
    assert_response :success
    assert_template 'list'
  end

  def test_export
    get :export,:id=>@assay.id
    assert_response :success
  end

  def test_import
    get :import,:id=>@assay.id
    assert_response :success
  end

  def test_import_file_good_file
    assay = Assay.new({:name => 'Import1', :description => 'Dummy', :project_id=>1})
    assert assay.save
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','test-parameters.csv'))
    post :import_file, :id=>assay.id,:file=>file,:types=>false,:roles=>false
    assert_nil flash[:error],flash[:error]
    assert_nil flash[:warning],flash[:warning]
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end

  def test_import_file_poor_file
    assay = Assay.new({:name => 'Import2', :description => 'Dummy', :project_id=>1})
    assert assay.save
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','test2-parameters.csv'))
    post :import_file, :id=>assay.id,:file=>file,:types=>false,:roles=>true
    assert_nil flash[:error],flash[:error]
    assert flash[:warning],flash[:warning]
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end

  def test_test_save_in_error_ajax
    get :test_save,:id=>35435353,:element=>'test',"value"=>"222",:format=>'js'
    assert !assigns(:successful)
    assert_response :success
  end

  def test_test_save_ajax
    get :test_save,:id=>@item.id,:element=>'test',"value"=>"222",:format=>'js'
    assert_response :success
  end

  def test_test_save_with_value
    get :test_save,:id=>@item.id,:value=>"222", :element=>"cell_10100_3"
    assert_response :success
  end

  def test_test_save_with_value_ajax
    get :test_save,:id=>@item.id,:value=>"222", :element=>"cell_10100_3",:format=>'js'
    assert_response :success
  end

  def test_show
    get :show, :id => @item.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:assay_parameter)
    assert assigns(:assay_parameter).valid?
  end

  def test_show_denied
    @user = User.find(3)
    @assay = @project.assays[0]
    @item = @assay.parameters[0]
    @request.session[:current_project_id] =1
    @request.session[:current_user_id] = 1    
    get :show, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'access_denied'
  end

  def test_new
    get :new,:id=>@assay.id
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:assay_parameter)
  end


  def test_create
    num_assay_parameters = AssayParameter.count
    post :create, :id=>@assay.id, :assay_parameter => {}
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns['type']
    assert_equal num_assay_parameters, AssayParameter.count
  end

  def test_create_add_valid
    num_assay_parameters = AssayParameter.count
    post :create, :id=>@assay.id, :commit=>'Add', :assay_parameter=>{:name=>"Concentration_knd", :display_unit=>"", :default_value=>"", :data_format_id=>"4", :parameter_role_id=>"6", :parameter_type_id=>"24", :data_type_id=>"2", :description=>"Concentration of compounds etc"}
    assert_redirected_to :action=>'new'
    assert flash[:notice]
    assert_equal num_assay_parameters+1, AssayParameter.count
  end
  
  def test_create_valid
    num_assay_parameters = AssayParameter.count
    post :create, :id=>@assay.id, :assay_parameter=>{:name=>"Concentration_knd", :display_unit=>"", :default_value=>"", :data_format_id=>"4", :parameter_role_id=>"6", :parameter_type_id=>"24", :data_type_id=>"2", :description=>"Concentration of compounds etc"}
    assert_redirected_to :action=>'new'
    assert flash[:notice]
    assert_equal num_assay_parameters+1, AssayParameter.count
  end
  

  def test_destroy
    unused_parameter = AssayParameter.create(
      :assay_id=>@assay.id,
      :name=>"Concentration_knd", 
      :display_unit=>"", 
      :default_value=>"", 
      :data_format_id=>"4", 
      :parameter_role_id=>"6", 
      :parameter_type_id=>"24", :data_type_id=>"2", 
      :description=>"Concentration of compounds etc"
    );
    post :destroy, :id=>unused_parameter.id
    assert_redirected_to :action=>'list'
  end
  

  def test_edit
    get :edit, :id => @item.id
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:assay_parameter)
    assert assigns(:assay_parameter).valid?
  end
     
  def test_tree_root
    get :tree,:id=>@assay.id
    assert_response :success    
  end  

  def test_tree_role
    get :tree,:id=>@assay.id, :node=>ParameterRole.find(:first).id
    assert_response :success    
  end  

  def test_tree_queue
    get :tree,:id=>@assay.id, :node=>'queue'
    assert_response :success    
  end  
  
  def test_refresh_type
    get :refresh,:id=>@assay.id, :parameter_type_id=> @parameter_type1.id
    assert_response :success    
  end  

  def test_refresh_type_js
    get :refresh,:id=>@assay.id, :parameter_type_id=> @parameter_type1.id,:format=>'js'
    assert_response :success    
  end  

  def test_refresh_type_with_alias
    get :refresh,:id=>@assay.id, :parameter_type_id=> @parameter_type2.id
    assert_response :success    
  end  

  def test_refresh_type_with_alias_js
    get :refresh,:id=>@assay.id, :parameter_type_id=> @parameter_type2.id,:format=>'js'
    assert_response :success    
  end  
  
  def test_refresh_no_parameters
    get :refresh,:id=>@assay.id
    assert_response :success    
  end  
  
  def test_refresh_with_alias_name
    get :refresh,:id=>@assay.id, :parameter_type_id=> @parameter_type2.id,:alias=>@parameter_type_alias.name
    assert_response :success    
  end  
  
  def test_refresh_with_alias_name_js
    get :refresh,:id=>@assay.id, :parameter_type_id=> @parameter_type2.id,:alias=>@parameter_type_alias.name,:type=>'js'
    assert_response :success    
  end  
  
  def test_update
    post :update, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list', :id => 1
  end

  def test_update_invalid
    post :update, :id => @item.id, :assay_parameter=>{:name=>''}
    assert_response :success
    assert_template 'edit'   
  end
  
end
