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
    @item = User.find(3).element(:first,:conditions=>"type='ProjectContent'")
    
  end
 
  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_show_article
   get :show,  :id=>"1"
   assert_response :success
  end
 def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_setup
    assert_not_nil @item
    assert_not_nil @item.id
    assert_not_nil @item.parent
    assert_not_nil @item.name
  end
  
  def test_show
    get :show, :id => @item.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:project_element)
  end


  def test_new
    get :new, :id=>@item.parent_id
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:project_element)
  end

  def test_create
    post :create, :id=>@item.parent_id, :project_element => {:name=>'dfdsfd',:title=>'testing',:to_html=>'body'}
    assert_response  :redirect
    assert_redirected_to :action => 'show'
    assert_not_nil assigns(:project_element)
    assert assigns(:project_element).valid?
    assert !assigns(:project_element).new_record?
  end

  def test_edit
    get :edit, :id =>  @item.id
    assert_response :success
    assert_template 'edit'
  end
#
# @todo rjs need to set data pattern for update
##
#  def test_update
#    post :update, { :id=> @item.id, :project_element=>{} }
#    assert_response :redirect
#    assert_redirected_to :action => 'show', :id => @item.id
#  end

end
