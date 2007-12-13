require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/organize/study_parameters_controller"

# Re-raise errors caught by the controller.
class Organize::StudyParametersController; def rescue_action(e) raise e end; end

class Organize::StudyParametersControllerTest < Test::Unit::TestCase
  # fixtures :study_parameters

  def setup
    @controller = Organize::StudyParametersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @study = Study.find(:first)
    @item = StudyParameter.find(:first)
  end

  def test_setup
    assert_not_nil @controller
    assert_not_nil @request
    assert_not_nil @response
    assert_not_nil @study
    assert_not_nil @item
    assert_not_nil @item.id
  end
  
  def test_index
    get :index,:id=>@study.id
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list,:id=>@study.id
    assert_response :success
    assert_template 'list'
  end

  def test_show
    get :show, :id => @item.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:study_parameter)
    assert assigns(:study_parameter).valid?
  end

  def test_new
    get :new,:id=>@study.id
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:study_parameter)
  end

  def test_create
    num_study_parameters = StudyParameter.count
    post :create, :id=>@study.id, :study_parameter => {}
    assert_response :success
    assert_template 'new'
    assert_equal num_study_parameters, StudyParameter.count
  end

  def test_edit
    get :edit, :id => @item.id
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:study_parameter)
    assert assigns(:study_parameter).valid?
  end

  def test_update
    post :update, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list', :id => 1
  end

end
