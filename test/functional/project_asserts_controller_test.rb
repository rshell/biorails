require File.dirname(__FILE__) + '/../test_helper'
require "project_assets_controller"

# Re-raise errors caught by the controller.
class ProjectAssetsController; def rescue_action(e) raise e end; end

class ProjectAssetsControllerTest < Test::Unit::TestCase
  def setup
    @controller = ProjectAssetsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @model = ProjectAsset
    @item = @model.find(:first)
    @folder = @item.parent
  end

  def test_setup
    assert_not_nil @folder
    assert_not_nil @item
    assert_not_nil @item.element_type
    assert_not_nil @item.id
    assert_not_nil @item.parent
    assert_not_nil @item.name
  end
  #
  # Test a show of a item
  #
  def test_show
    get :show, :id => @item.id,:style=>'file'
    assert_response :success
    assert_template 'show'
    assert assigns(:project_element)
  end

   #
  # Test a show of a item
  #
  def test_show_in_panel
    get :show, :id => @item.id,:style=>'file',:format=>'ext'
    assert_response :success
    assert_template '_show'
    assert assigns(:project_element)
  end
 
  def test_show_as_xml
    get :show, :id => @item.id,:style=>'file',:format=>'xml'
    assert_response :success
    assert assigns(:project_element)
  end

  def test_show_as_pdf
    get :show, :id => @item.id,:style=>'file',:format=>'pdf'
    assert assigns(:project_element)
    assert_response 406
  end

  def test_show_as_js
    get :show, :id => @item.id,:style=>'file',:format=>'js'
    assert_response :success
    assert assigns(:project_element)
  end
  #
  # Test a new call to controller
  #
  def test_new
    get :new, :id => @item.parent_id,:style=>'file'
    assert_response :success
    assert_template 'new'
    assert assigns(:project_element)
  end
   
  def test_new_ajax
    get :new,:style=>'file', :id => @item.parent_id,:format=>'js'
    assert_response :success
    assert assigns(:project_element)
  end
   
  #
  # Test asset upload
  #
  def test_upload_with_failure
    get :create,:style=>'file', :id => @item.parent_id
    assert_response :success
    assert_template 'new'
  end

  #
  # Test asset upload
  #
  def test_upload_with_failure
    get :create,:style=>'file', :id => @item.parent_id
    assert_response :success
    assert_template 'new'
  end
     
  def test_update_big_image
     file = ActionController::TestUploadedFile.new(File.join(RAILS_ROOT,'test','fixtures','files','parrot_7682.jpg'),'image/jpeg',true)
    
     post :create, :id => @item.parent_id,:style=>'file',:commit=>"Save", 
         :project_element=>{ :project_id=>"1",:file=>file, 
         :title=>"test2", :title=>"test", :path=>"rjs-350"} 
    assert assigns(:project_element)
    item = assigns(:project_element)
    assert_ok item
    assert_response :redirect
    assert item.image?,"should be a image"
    assert item.icon,"get a icon"
    assert item.asset,"should have a asset"
    assert item.asset.filename,"filename"
    assert_equal 'image/jpeg', item.content_type
  end
  #
  # Test a edit call to controller
  #
  def test_edit
    get :edit, :id =>  @item.id,:style=>'file'
    assert_response :success
    assert_template 'edit'
  end

  def test_edit_ajax
    get :edit, :id =>  @item.id,:format=>'js',:style=>'file'
    assert_response :success
    assert assigns(:project_element)
  end
  
NEW_NAME="Sunset.jpg"
NEW_TITLE="Sunset.jpg" 
  #
  # Test a update call to controller
  #
  def test_update
    item_old = ProjectAsset.find(30)
    assert_not_equal NEW_NAME,item_old.name
    assert_not_equal NEW_TITLE,item_old.asset.title
    
    post :update,:id=>30,:commit=>"Save",:style=>'file',
      :project_element=>{:name=>NEW_NAME, 
                       :project_id=>"1", 
                       :title=>"Sunset.jpg", 
                       :id=>"2", 
                       :title=>NEW_TITLE,
                       :position=>"2", 
                       :path=>"Sunset.jpg"}     
    assert_response :redirect
    assert_redirected_to :action => 'show'
    item = ProjectAsset.find(30)
    assert_equal  NEW_NAME,item.name,item.to_xml
  end

  def test_update_ajax
    item_old = ProjectAsset.find(30)
    assert_not_equal NEW_NAME,item_old.name
    assert_not_equal NEW_TITLE,item_old.asset.title
    
    post :update,:id=>30,"commit"=>"Save",:style=>'file', :format=>'js',
      :project_element=>{:name=>NEW_NAME, 
                       :project_id=>"1", 
                       :title=>"Sunset.jpg", 
                       :id=>"2", 
                       :title=>NEW_TITLE,
                       :position=>"2", 
                       :path=>"Sunset.jpg"}     
    assert_response :success
    assert assigns(:project_element)
    item = ProjectAsset.find(30)
    assert_equal  NEW_NAME,item.name,item.to_xml
  end

 
  
 
end
