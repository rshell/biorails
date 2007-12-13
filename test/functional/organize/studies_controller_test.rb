require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/organize/studies_controller"

# Re-raise errors caught by the controller.
class Organize::StudiesController; def rescue_action(e) raise e end; end

class Organize::StudiesControllerTest < Test::Unit::TestCase
  # fixtures :studies

	NEW_STUDY = {}	# e.g. {:name => 'Test Study', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

  def setup
    @controller = Organize::StudiesController.new
    @request    =ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @item = Study.find(:first)
  end

  def test_setup
    assert_not_nil @controller
    assert_not_nil @request
    assert_not_nil @response
    assert_not_nil @item
    assert_not_nil @item.id
  end
  
  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list
    assert_response :success
    assert_template 'list'
  end

  def test_show
    get :show, :id => @item.id
    assert_response :success
    assert_template 'show'
  end

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
  end

  def test_create
    num = Study.count
    post :create, :study => {}
    assert_response :success
    assert_template 'new'
    assert_equal num, Study.count
  end

  def test_edit
    get :edit, :id => @item.id
    assert_response :success
    assert_template 'edit'
  end

  def test_update
    post :update, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Study.find(@item.id)
    post :destroy, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_raise(ActiveRecord::RecordNotFound) {
      Study.find(@item.id)
    }
  end

 
end
