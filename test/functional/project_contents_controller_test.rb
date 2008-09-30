require File.dirname(__FILE__) + '/../test_helper'
require "project_contents_controller"

# Re-raise errors caught by the controller.
class ProjectContentsController; def rescue_action(e) raise e end; end

class ProjectContentsControllerTest < Test::Unit::TestCase
  def setup
    @controller = ProjectContentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    User.current = User.find(3)
    @item = ProjectContent.list(:first,:conditions=>"parent_id is not null")
    @folder = @item.parent    
  end  

  def test_show_article
    get :show, :style=>'html',  :id=>@item.id
    assert_response :success
  end
  
  def test_setup
    assert_not_nil @folder
    assert_not_nil @item
    assert_not_nil @item.element_type
    assert_not_nil @item.id
    assert_not_nil @item.parent
    assert_not_nil @item.name
  end

  def test_show
    get :show,:style=>'html', :id => @item.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:project_element)
  end

  def test_new
    get :new,:style=>'html', :id=> @folder.id
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:project_element)
  end

  def test_new_js
    get :new,:style=>'html', :id=> @folder.id,:format=>'js'
    assert_response :success
    assert_template '_messages'
    assert_not_nil assigns(:project_element)
  end

  def test_create
    post :create,:style=>'html', :id=> @folder.id, 
      :project_element => {:name=>'dfdsfd',:title=>'testing',:content_data=>'body'}
    assert_response  :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:project_element)
    assert assigns(:project_element).valid?
    assert !assigns(:project_element).new_record?
  end

  def test_create_js
    post :create,:style=>'html', :id=> @folder.id,:format=>'js', 
       :project_element => {:name=>'dfds2',:title=>'testing',:content_data=>'body'}
    assert_response :success
    assert_not_nil assigns(:project_element)
    assert assigns(:project_element).valid?
    assert !assigns(:project_element).new_record?
  end

  def test_create_failed_js
    post :create,:style=>'html', :id=>@folder.id,:format=>'js', 
       :project_element => {:name=>nil}
    assert_response :success
    assert_not_nil assigns(:project_element)
    assert !assigns(:project_element).valid?
  end

  def test_edit
    get :edit, :style=>'html', :id =>  @item.id
    assert_response :success
    assert_template 'edit'
  end
  
  def test_edit_js
    get :edit,:style=>'html', :id =>  @item.id, :format=>'js'
    assert_response :success
  end
  
  def test_create_invalid
    post :create,:style=>'html', :id=>@folder.id, 
       :project_element => {:id=>@item.id,:name=>'',:title=>'testing',:data=>'body'}
    assert :success #reloads the existing page
    assert_not_nil assigns(:project_element)
    assert !assigns(:project_element).valid? 
    assert assigns(:project_element).errors
    assert assigns(:project_element).errors[:name]
    assert_empty_error_field('project_element[name]')
    assert_tag :tag=>'li', :content=>"Name can't be blank"
  end 
    
  def test_update_without_name_should_not_be_valid
    post :update,:style=>'html', :id=>@item.id, 
    :project_element => {:id=>@item.id,:name=>nil,:title=>'testing',:data=>'body'}
    assert_redirected_to :action=>:show
    assert !assigns(:project_element).valid? 
    assert flash[:error]
  end

  def test_update_with_new_name
    post :update,:style=>'html', :id=>@item.id, 
    :project_element => {:id=>@item.id,:name=>'new_name',:title=>'testing',:data=>'body'}
    assert :redirected
    assert_nil flash[:error]
  end

  def test_update_with_new_name_js
    post :update,:style=>'html', :id=>@item.id, :format=>'js', 
    :project_element => {:id=>@item.id,:name=>'new_name',:title=>'testing',:data=>'body'}
    assert :redirected
    assert_nil flash[:error]
  end

end
