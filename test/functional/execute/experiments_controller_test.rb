require File.dirname(__FILE__) + '/../../test_helper'
require "experiments_controller"

# Re-raise errors caught by the controller.
class Execute::ExperimentsController; def rescue_action(e) raise e end; end

class Execute::ExperimentsControllerTest < Test::Unit::TestCase


  def setup
    @controller = Execute::ExperimentsController.new
    @request    = ActionController::TestRequest.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @response   = ActionController::TestResponse.new
    @first = Experiment.find(:first)
  end

  def test_setup
    assert_not_nil @controller
    assert_not_nil @request
    assert_not_nil @response
    assert_not_nil @first
    assert_not_nil @first.id
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
    assert_not_nil assigns(:report)
  end

  def test_show
    get :show, :id => @first.id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:experiment)
    assert assigns(:experiment).valid?
  end

  def test_new
    get :new, :id => Study.find(:first).id
    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:experiment)
  end

  def test_create
    num_experiments = Experiment.count

    post :create, :experiment => {}

    assert_response :success
    assert_template 'new'

    assert_equal num_experiments, Experiment.count
  end

  def test_edit
    get :edit, :id => @first.id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:experiment)
    assert assigns(:experiment).valid?
  end

  def test_update
    post :update, :id => @first.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Experiment.find(@first.id)

    post :destroy, :id => @first.id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Experiment.find(@first.id)
    }
  end
end
