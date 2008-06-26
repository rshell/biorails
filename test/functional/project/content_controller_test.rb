require File.dirname(__FILE__) + '/../../test_helper'
require "content_controller"

# Re-raise errors caught by the controller.
class Project::ContentController; def rescue_action(e) raise e end; end

class Project::ContentControllerTest < Test::Unit::TestCase
  def setup
    @controller = Project::ContentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @item = getItem
    
  end
  
  def getItem
    @item = ProjectElement.find(:first,:conditions=>"parent_id is not null and type='ProjectContent'")
  end

  def getFolder
    @item = ProjectElement.find(:first,:conditions=>"type='ProjectFolder'")
  end
  

  def test_show_article
    get :show,  :id=>"1"
    assert_response :success
  end
  
  def test_setup
    assert_not_nil @item
    assert_not_nil @item.id
    assert_not_nil @item.parent
    assert_not_nil @item.name
  end
  
  def test_index
    get :index, :id => @item.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:project_element)
  end

  def test_show
    get :show, :id => @item.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:project_element)
  end

  def test_new
    get :new, :id=>getFolder.id
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:project_element)
  end

  def test_new_js
    get :new, :id=>getFolder.id,:format=>'js'
    assert_response :success
    assert_template '_messages'
    assert_not_nil assigns(:project_element)
  end

  def test_create
    post :create, :id=>getFolder.id, :project_element => {:name=>'dfdsfd',:title=>'testing',:body_html=>'body'}
    assert_response  :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:project_element)
    assert assigns(:project_element).valid?
    assert !assigns(:project_element).new_record?
  end

  def test_create_js
    post :create, :id=>getFolder.id,:format=>'js', :project_element => {:name=>'dfds2',:title=>'testing',:body_html=>'body'}
    assert_response :success
    assert_not_nil assigns(:project_element)
    assert assigns(:project_element).valid?
    assert !assigns(:project_element).new_record?
  end

  def test_create_failed_js
    post :create, :id=>getFolder.id,:format=>'js', :project_element => {:name=>nil,:body_html=>''}
    assert_response :success
    assert_not_nil assigns(:project_element)
    assert !assigns(:project_element).valid?
  end

  def test_diff    
    get :diff, :id =>  @item.id,:version=>@item.content.id
    assert_response :success
    assert_template 'diff'
  end
 
  def test_diff_ajax 
    get :diff, :id =>  @item.id,:version=>@item.content.id,:format=>'js'
    assert_response :success
    assert_template '_diff'
  end
 

  def test_edit
    get :edit, :id =>  getItem.id
    assert_response :success
    assert_template 'edit'
  end
  
  def test_edit_js
    get :edit, :id =>  getItem.id, :format=>'js'
    assert_response :success
  end
  
  def test_create_invalid
    post :create, :id=>getFolder.id, :project_element => {:id=>@item.id,:name=>'',:title=>'testing',:body_html=>'body'}
    assert :success #reloads the existing page
    assert_not_nil assigns(:project_element)
    assert !assigns(:project_element).valid? 
    assert assigns(:project_element).errors
    assert assigns(:project_element).errors[:name]
    assert_empty_error_field('project_element[name]')
    assert_tag :tag=>'li', :content=>"Name can't be blank"
  end 
    
  def test_update_without_name_should_not_be_valid
    post :update, :folder_id=>getFolder.id, :project_element => {:id=>getItem.id,:name=>'',:title=>'testing',:body_html=>'body'}
    assert_redirected_to :action=>:show
     
    assert_equal "Failed to save content <br/> Name can't be blank", flash[:error]
  end

  def test_update_with_new_name
    post :update, :folder_id=>getFolder.id, :project_element => {:id=>getItem.id,:name=>'new_name',:title=>'testing',:body_html=>'body'}
    assert :redirected
    assert_nil flash[:error]
  end

  def test_update_with_new_name_js
    post :update, :folder_id=>getFolder.id,:format=>'js', :project_element => {:id=>getItem.id,:name=>'new_name',:title=>'testing',:body_html=>'body'}
    assert :redirected
    assert_nil flash[:error]
  end

end
