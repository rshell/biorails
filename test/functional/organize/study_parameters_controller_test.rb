require File.dirname(__FILE__) + '/../../test_helper'
require 'organize/study_parameters_controller'

# Re-raise errors caught by the controller.
class Organize::StudyParametersController; def rescue_action(e) raise e end; end

class Organize::StudyParametersControllerTest < Test::Unit::TestCase
  fixtures :study_parameters

  def setup
    @controller = Organize::StudyParametersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
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

    assert_not_nil assigns(:study_parameters)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:study_parameter)
    assert assigns(:study_parameter).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:study_parameter)
  end

  def test_create
    num_study_parameters = StudyParameter.count

    post :create, :study_parameter => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_study_parameters + 1, StudyParameter.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:study_parameter)
    assert assigns(:study_parameter).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil StudyParameter.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      StudyParameter.find(1)
    }
  end
end
