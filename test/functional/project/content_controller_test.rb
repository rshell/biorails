require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/project/content_controller"

# Re-raise errors caught by the controller.
class Project::ContenController; def rescue_action(e) raise e end; end

class Project::ContentControllerTest < Test::Unit::TestCase
  def setup
    @controller = Project::ContentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @item = ProjectAsset.find(:first)
  end

  # Replace this with your real tests.
  def test_truth
    assert true
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

    assert_not_nil assigns(:memberships)
  end

  def test_show
    get :show, :id => @item.id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:membership)
    assert assigns(:membership).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:membership)
  end

  def test_create
    num_memberships = Membership.count

    post :create, :membership => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_memberships + 1, Membership.count
  end

  def test_edit
    get :edit, :id =>  @item.id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:membership)
    assert assigns(:membership).valid?
  end

  def test_update
    post :update, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {      Membership.find( @item.id)    }

    post :destroy, :id =>  @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Membership.find( @item.id)
    }
  end
end
