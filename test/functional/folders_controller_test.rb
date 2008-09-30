require File.dirname(__FILE__) + '/../test_helper'
require "folders_controller"

# Re-raise errors caught by the controller.
class FoldersController; def rescue_action(e) raise e end; end

class FoldersControllerTest < Test::Unit::TestCase
  def setup
    @controller = FoldersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 2
    @request.session[:current_user_id] = 3
    @model = ProjectFolder
    @project = Project.find(2)
    @item = @project.home
  end

  
  # Test a index call to controller
  #
  def test_index
    get :index
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

  #
  # Test a list call to controller
  #
  def test_list
    get :list
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

  #
  # Test a show of a item
  #
  def test_show
    get :show, :id => @item.id
    assert_response :success
    assert_template 'show'
  end

  def test_show_denied
    User.current = User.find(9)
    Project.current = Project.find(2)
    @request.session[:current_project_id] =2
    @request.session[:current_user_id] = 9   
    get :show, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'access_denied'
  end 
  
  def test_show_js
    get :show, :id => @item.id,:format=>'js'
    assert_response :success
  end

  def test_show_xml
    get :show, :id => @item.id,:format=>'xml'
    assert_response :success
  end

  def test_document
    get :document, :id => @item.id
    assert_response :success
    assert_template 'document'
  end
  
  def test_document_xml
    get :document, :id => @item.id,:format=>'xml'
    assert_response :success
  end

  def test_document_ext
    get :document, :id => @item.id,:format=>'ext'
    assert_response :success
    assert_template '_document'
  end
  
  def test_document_js
    get :document, :id => @item.id,:format=>'js'
    assert_response :success
  end
  
  def test_print
    get :print, :id => @item.id
    assert_response :success
    assert_template 'print'
  end
  
  def test_print_pdf
    get :print, :id => @item.id,:format=>'pdf'
    assert_response :success
  end
  
  def test_print_xml
    get :print, :id => @item.id,:format=>'xml'
    assert_response :success
  end
    
  def test_grid
    get :grid, :id => @item.id
    assert_response :success
    assert_template '_grid'
  end
  
  def test_grid_filtered
    get :grid, :id => @item.id,:where=>{
        1=>{:field=>'name',:data=>{:value=>'A',:comparison=>'eq'}},
        2=>{:field=>'name',:data=>{:value=>'A',:comparison=>'lt'}},
        3=>{:field=>'name',:data=>{:value=>'A',:comparison=>'gt'}},
        4=>{:field=>'name',:data=>{:value=>'A',:comparison=>'like'}},
        5=>{:field=>'id',:data=>{:value=>'1,2,3',:comparison=>'list'}}
    }
    assert_response :success
    assert_template '_grid'
  end
  
  def test_create
    get :create, :id => @item.id, :project_folder =>{:name=>'xxxx'}
    assert_response :redirect
    assert_redirected_to :action => 'show',:id => @item.id
  end

  def test_create_js
    get :create, :id => @item.id, :project_folder => {"name"=>"test", "project_id"=>Project.find(:first), "parent_id"=>@item.id},:format=>'js'
    assert_response :success
  end

    def test_create_js_failed
    get :create, :id => @item.id, :project_folder => {"name"=>nil},:format=>'js'
    assert_response :success
  end

  def test_create_xml
    get :create, :id => @item.id, :project_folder =>{:name=>'xxxx'},:format=>'xml'
    assert_response 201
  end
  
  def test_create_failed
    #
    # Pass and redirect to show
    #
    get :create, :id => @item.id, :project_folder =>{:name=>'xxxx',:title=>'testing'}
    assert_redirected_to :action => 'show'
    #
    # Now fail and display new page
    #
    get :create, :id => @item.id, :project_folder =>{:name=>'xxxx',:title=>'testing'}
    assert_response :success
    assert_template 'new'
  end
  
  #
  # Test a new call to controller
  #
  def test_new
    get :new, :id => @item.id
    assert_response :success
    assert_template 'new'
  end

  def test_new_js
    get :new, :id => @item.id,:format=>'js'
    assert_response :success
  end
  
  def test_new_xml
    get :new, :id => @item.id,:format=>'xml'
    assert_response :success
  end
  
  #
  # Test a edit call to controller
  #
  def test_edit
    get :edit, :id =>  @item.id
    assert_response :success
    assert_template 'edit'
  end

    def test_edit_js
    get :edit, :id =>  @item.id,:format=>'js'
    assert_response :success
    assert_template '_actions'
  end

  #
  # Test a update call to controller
  #
  def test_update
    post :update, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert assigns(:project_folder)
    assert assigns(:project_folder).valid?
  end

  def test_update_failed
    post :update, :id => @item.id,:project_folder=>{:name=>nil}
    assert_response :redirect
    assert_redirected_to :action => 'edit'
    assert assigns(:project_folder)
    assert !assigns(:project_folder).valid?
  end
  
  def test_update_js
    post :update, :id => @item.id,:format=>'js'
    assert_response :success
    assert_template '_actions'
    assert assigns(:project_folder)
    assert assigns(:project_folder).valid?
  end

  def test_update_failed_js
    post :update, :id => @item.id,:project_folder=>{:name=>nil},:format=>'js'
    assert_response :success
    assert_template '_actions'
    assert assigns(:project_folder)
    assert !assigns(:project_folder).valid?
  end

  def test_reorder_element
    @item1 = ProjectElement.find(30)
    @item2 = ProjectElement.find(40)
    post :reorder_element, :id => @item2.id,:before=>@item1.id
    assert_response :success
    assert_template 'show'
    assert_ok assigns(:project_element)
  end
  
  def test_reorder_element_ajax
    @item1 = ProjectElement.find(30)
    @item2 = ProjectElement.find(40)
    post :reorder_element, :id => @item2.id,:before=>@item1.id,:format=>'js'
    assert_response :success
    assert_ok assigns(:project_element)
  end
  
  #
  # Test a destroy call to controller
  #
  def test_destroy
    assert_nothing_raised {      @model.find( @item.id)    }
    post :destroy, :id =>  @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_raise(ActiveRecord::RecordNotFound) {
      @model.find( @item.id)
    }
  end
  def test_create_ok
    post :create, :id=>@item.id, "project_folder"=>{"name"=>"test", "project_id"=>Project.find(:first), "parent_id"=>@item.id}
    assert_response :redirect
    assert_equal 'ProjectFolder was successfully created.', flash[:notice]
    assert_redirected_to :action => 'show'
  end
  
  def test_create_invalid
    post :create, :id=>@item.id, "project_folder"=>{"name"=>"", "project_id"=>Project.find(:first), "parent_id"=>@item.id}
    assert :success #reloads the existing page
    assert_empty_error_field('project_folder[name]')
  end 
  
  def test_update_should_change_item_when_valid
     post :create, :id=>@item.id, "project_folder"=>{"name"=>"test", "project_id"=>Project.find(:first), "parent_id"=>@item.id}
   assert_redirected_to :action=>'show'
  end
  
  def test_update_should_not_change_item_when_valid
    post :update, :id=>@item.id, "project_folder"=>{"name"=>"", "project_id"=>Project.find(:first), "parent_id"=>@item.id}
    assert_response :redirect
  end
 
  def test_select 
    post :select, :value=>""
    assert_response :success
    assert assigns(:choices)
    assert assigns(:list)
  end
  
  def test_add_element
    project_1_asset = ProjectAsset.find(30)
    post :add_element, :id=>project_1_asset.id, :folder_id=>@item.id
    assert_response :success
    assert_not_nil assigns['project_folder']
    assert_not_nil assigns['source']
    assert_not_nil assigns['new_element']
  end
  
  def test_add_element_before
    project_1_asset = ProjectAsset.find(30)
    post :add_element, :id=>project_1_asset.id, :folder_id=>@item.id, :before=>@item.children[0].id
    assert_response :success
    assert_not_nil assigns['project_folder']
    assert_not_nil assigns['source']
    assert_not_nil assigns['new_element']
  end
  
  def test_add_element_ajax
    project_1_asset = ProjectAsset.find(30)
    post :add_element, :id=>project_1_asset.id, :folder_id=>@item.id,:format=>'js'
    assert_response :success
    assert_not_nil assigns['project_folder']
    assert_not_nil assigns['source']
    assert_not_nil assigns['new_element']  
  end
  
  def test_cannot_add_element
    post :add_element, :id=>@item.id, :folder_id=>@item.id
    assert_response :success
    assert_not_nil assigns['project_folder']
    assert_not_nil assigns['source']
  end
  
end
