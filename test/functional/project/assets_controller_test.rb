require File.dirname(__FILE__) + '/../../test_helper'
require "assets_controller"

# Re-raise errors caught by the controller.
class Project::AssetsController; def rescue_action(e) raise e end; end

class Project::AssetsControllerTest < Test::Unit::TestCase
  def setup
    @controller = Project::AssetsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @model = ProjectAsset
    @item = @model.find(:first)
  end

  #
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
    assert assigns(:project_asset)
  end

   #
  # Test a show of a item
  #
  def test_show_in_panel
    get :show, :id => @item.id,:format=>'ext'
    assert_response :success
    assert_template '_show'
    assert assigns(:project_asset)
  end
 
  def test_show_as_xml
    get :show, :id => @item.id,:format=>'xml'
    assert_response :success
    assert assigns(:project_asset)
  end

  def test_show_as_pdf
    get :show, :id => @item.id,:format=>'pdf'
    assert assigns(:project_asset)
    assert_response 406
  end

  def test_show_as_js
    get :show, :id => @item.id,:format=>'js'
    assert_response :success
    assert assigns(:project_asset)
  end
  #
  # Test a new call to controller
  #
  def test_new
    get :new, :id => @item.parent_id
    assert_response :success
    assert_template 'new'
    assert assigns(:project_asset)
  end
   
  def test_new_ajax
    get :new, :id => @item.parent_id,:format=>'js'
    assert_response :success
    assert assigns(:project_asset)
  end
   
  #
  # Test asset upload
  #
  def test_upload_with_failure
    get :upload, :id => @item.parent_id
    assert_response :success
    assert_template 'new'
  end

  #
  # Test asset upload
  #
  def test_upload_with_failure
    get :upload, :id => @item.parent_id
    assert_response :success
    assert_template 'new'
  end
     
  def test_update_big_image
     file = ActionController::TestUploadedFile.new(File.join(RAILS_ROOT,'test','fixtures','files','parrot_7682.jpg'),'image/jpeg',true)
    
     post :upload,:id => @item.parent_id,:commit=>"Save", :project_asset=>{
         :project_id=>"1", :uploaded_data=>file, 
         :title=>"test2", :description=>"test", :path=>"rjs-350"} 
    assert_response :redirect
    assert assigns(:project_asset)
    item = assigns(:project_asset)
    assert_ok item
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
    get :edit, :id =>  @item.id
    assert_response :success
    assert_template 'edit'
  end

  def test_edit_ajax
    get :edit, :id =>  @item.id,:format=>'js'
    assert_response :success
    assert assigns(:project_asset)
  end
  
NEW_NAME="Sunset.jpg"
NEW_TITLE="Sunset.jpg"
NEW_DESCRIPTION="<P>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</P>"  
  #
  # Test a update call to controller
  #
  def test_update
    item_old = ProjectAsset.find(30)
    assert_not_equal NEW_NAME,item_old.name
    assert_not_equal NEW_DESCRIPTION,item_old.description
    assert_not_equal NEW_TITLE,item_old.asset.title
    
    post :update,:id=>30,"commit"=>"Save", 
      :project_asset=>{:name=>NEW_NAME, 
                       :project_id=>"1", 
                       :title=>"Sunset.jpg", 
                       :id=>"2", 
                       :description=>NEW_DESCRIPTION, 
                       :title=>NEW_TITLE,
                       :position=>"2", 
                       :path=>"Sunset.jpg"}     
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
    item = ProjectAsset.find(30)
    assert_equal  NEW_NAME,item.name,item.to_xml
    assert_equal NEW_DESCRIPTION,item.description,item.to_xml
    assert_equal NEW_TITLE,item.asset.title,item.asset.to_xml
  end

  def test_update_ajax
    item_old = ProjectAsset.find(30)
    assert_not_equal NEW_NAME,item_old.name
    assert_not_equal NEW_DESCRIPTION,item_old.description
    assert_not_equal NEW_TITLE,item_old.asset.title
    
    post :update,:id=>30,"commit"=>"Save", :format=>'js',
      :project_asset=>{:name=>NEW_NAME, 
                       :project_id=>"1", 
                       :title=>"Sunset.jpg", 
                       :id=>"2", 
                       :description=>NEW_DESCRIPTION, 
                       :title=>NEW_TITLE,
                       :position=>"2", 
                       :path=>"Sunset.jpg"}     
    assert_response :success
    assert assigns(:project_asset)
    item = ProjectAsset.find(30)
    assert_equal  NEW_NAME,item.name,item.to_xml
    assert_equal NEW_DESCRIPTION,item.description,item.to_xml
    assert_equal NEW_TITLE,item.asset.title,item.asset.to_xml
  end

 
  
 
end
