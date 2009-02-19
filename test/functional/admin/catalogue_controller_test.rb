require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/admin/catalogue_controller"

# Re-raise errors caught by the controller.
class Admin::CatalogueController; def rescue_action(e) raise e end; end

class Admin::CatalogueControllerTest < BiorailsTestCase

  NEW_PARAMETER_TYPE = {}	# e.g. {:name => 'Test ParameterType', :description => 'Dummy'}
  REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

  def setup
    @controller = Admin::CatalogueController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @user = User.current = User.find(3)
    @project = Project.current = Project.find(2)        
    @request.session[:current_project_id] = @project.id
    @request.session[:current_user_id] = @user.id
    @item = DataConcept.find(:first)
  end

  def test_setup
    assert_not_nil @controller
    assert_not_nil @request
    assert_not_nil @response
    assert_not_nil @user
    assert_not_nil @project
    assert_not_nil @item   
    assert @user.right?(:catalogue,:list)    
    assert @user.right?(:catalogue,:show)    
    assert @user.right?(:catalogue,:new)    
    assert @user.right?(:catalogue,:admin)    
  end
        
  def test_index
    get :index
    assert_response :success
    assert_template 'list'
    assert_equal 1, assigns['data_concept'].id
    assert_equal 1, assigns['context'].id
  end

  def test_list
    get :list
    assert_response :success
    assert_template 'list'
    assert_equal 'BioRails', assigns['context'].name
  end

  def test_list_item
    get :list,:id =>@item.id
    assert_response :success
    assert_equal 1, assigns['data_concept'].id
    assert_template 'list'
  end

  def test_show
    get :show, :id => @item.id
    assert_response :success
    assert_template 'list'
    assert_equal 1, assigns['data_concept'].id
    assert_equal 1, assigns['context'].id
  end
  
  def test_show_xml
    get :show, :id => @item.id, :format=>'xml'
    assert 'application/xml', @response.content_type
  end

  def test_new
    get :new, :id => @item.id
    assert_response :success
    assert_template '_new_concept'
  end

  def test_edit
    get :edit, :id => @item.id
    assert_response :success
    assert_template '_edit_concept'
  end

  def test_create_failed
    num = DataConcept.count
    post :create,:id=>@item.id, :data_concept => {}
    assert_response :success
    assert_equal num , DataConcept.count
  end

  def test_create_ok
    num = DataConcept.count
    post :create,:id=>@item.id, :data_concept => {:name=>'xxxx',:description=>'xxxxx'}
    assert_response :redirect
    assert_equal num+1 , DataConcept.count
  end

  def test_update
    post :update, :id => @item.id,:data_concept => {}
    assert_response :redirect
    assert_redirected_to :action => 'list', :id => @item.id
  end
  
  def test_new_element
    get :new_element, :id => @item.id
    assert_response :success
    assert_template '_new_element'
  end
  
  def test_new_usage
    get :new_usage, :id => @item.id
    assert_response :success
    assert_template '_new_parameter_type'
  end
  
  def test_tree_root
    get :tree
    assert_response :success
    assert_template '_tree'
  end

  def test_tree_child
    get :tree, :node => @item.id
    assert_response :success
    assert_template '_tree'
  end
  
  def test_remove_element
    post :remove_element, :id=>4
    assert_equal 4, assigns['data_element'].id
    assert_redirected_to :action=>:list
  end
  def test_destroy
    post :destroy, :id=>4
    assert_equal 4, assigns['data_concept'].id
    assert_redirected_to :action=> 'list'
  end

  def test_create_element_no_id
    post :create_element
    assert_response :success
    assert_template '_new_element'
  end

  
  def test_create_element_failed
    post :create_element, :id=>4,:data_element=>{:name=>nil}
    assert_response :success
    assert_equal 4, assigns['data_concept'].id
  end

  def test_create_element_valid
    post :create_element, :id=>4,:data_element=>{
         "name"=>"Catalogue", "data_system_id"=>"1", "estimated_count"=>"3", 
        "description"=>"test", "content"=>"A,B,C",   "data_concept_id"=>"3", 
        "parent_id"=>"",  "style"=>"list"}
    assert_equal 4, assigns['data_concept'].id
    assert_redirected_to :action=> 'list'
  end

  def test_create_usage_failed
    post :create_usage, :id=>4
    assert_equal 4, assigns['data_concept'].id
    assert_response :success
    assert_template '_new_parameter_type'
  end

  def test_create_usage_no_id
    post :create_usage
    assert_nil assigns['data_concept']    
    assert_nil assigns['parameter_type']    
  end
   
  def test_create_usage_valid
    post :create_usage, :id=>4,:parameter_type=>{"name"=>"test", "data_type_id"=>"5", "description"=>"trest", 
      "data_concept_id"=>"4", "weighing"=>"0"}
    assert_equal 4, assigns['data_concept'].id
    assert_redirected_to :action=> 'list'
  end
  
end
