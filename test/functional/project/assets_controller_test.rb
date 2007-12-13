require File.dirname(__FILE__) + '/../../test_helper'
require "folders_controller"

# Re-raise errors caught by the controller.
class Project::FoldersController; def rescue_action(e) raise e end; end

class Project::FoldersControllerTest < Test::Unit::TestCase
  def setup
    @controller = Project::FoldersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @model = ProjectFolder
    @item = @model.find(:first)
  end

  # Replace this with your real tests.
  def test_truth
    assert true
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
    assert_not_nil assigns(:project_element)
    assert assigns(:project_element).valid?
  end

  def test_show_as_xml
    get :show, :id => @item.id,:format=>'xml'
    assert_response :success
  end

  def test_show_as_pdf
    get :show, :id => @item.id,:format=>'pdf'
    assert_response :success
  end

  def test_show_as_js
    get :show, :id => @item.id,:format=>'js'
    assert_response :success
  end

  #
  # Test a show of a item
  #
  def test_document
    get :document, :id => @item.id
    assert_response :success
    assert_template '_document'
  end
  
  #
  # Test a show of a item
  #
  def test_print
    get :print, :id => @item.id
    assert_response :success
  end

  #
  # Test a show of a item
  #
  def test_print
    get :grid, :id => @item.id
    assert_response :success
  end
    
  #
  # Test a new call to controller
  #
  def test_new
    get :new, :id => @item.id
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:project_element)
  end

  #
  # Test a edit call to controller
  #
  def test_edit
    get :edit, :id =>  @item.id
    assert_response :success
    assert_template 'edit'
  end

  #
  # Test a update call to controller
  #
  def test_update
    post :update, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  #
  # Test a destroy call to controller
  #
  def test_destroy
    assert_nothing_raised {      @model.find( @item.id)    }
    post :destroy, :id =>  @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end
end
