require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/organize/study_protocols_controller"

# Re-raise errors caught by the controller.
class Organize::StudyProtocolsController; def rescue_action(e) raise e end; end

class Organize::StudyProtocolsControllerTest < Test::Unit::TestCase
  # fixtures :study_protocols

  def setup
    @controller = Organize::StudyProtocolsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @study = Study.find(:first)
    @item = StudyProtocol.find(:first)
  end

  def test_index
    get :index, :id => @study.id
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list, :id => @study.id
    assert_response :success
    assert_template 'list'
    assert_not_nil assigns(:study_protocols)
  end

  def test_show
    get :show, :id => @item.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:study_protocol)
    assert assigns(:study_protocol).valid?
  end

  def test_new
    get :new, :id => @item.id
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:study_protocol)
  end

  def test_create
    num_study_protocols = StudyProtocol.count
    post :create, :id => @study.id, :study_protocol => {}
    assert_response :success
    assert_template 'new'
    assert_equal num_study_protocols, StudyProtocol.count
  end

  def test_edit
    get :edit, :id => @item.id
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:study_protocol)
    assert assigns(:study_protocol).valid?
  end

  def test_update
    post :update, :id => @item.id
    assert_response :success
    assert_template 'show'
  end

  def test_destroy
    assert_not_nil StudyProtocol.find(@item.id)
    post :destroy, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list'
    assert_raise(ActiveRecord::RecordNotFound) {
      StudyProtocol.find(@item.id)
    }
  end
end
