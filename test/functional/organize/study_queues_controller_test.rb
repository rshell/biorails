require File.dirname(__FILE__) + '/../../test_helper'
require  "#{RAILS_ROOT}/app/controllers/organize/study_queues_controller"

# Re-raise errors caught by the controller.
class Organize::StudyQueuesController; def rescue_action(e) raise e end; end

class Organize::StudyQueuesControllerTest < Test::Unit::TestCase
  # fixtures :study_queues

  def setup
    @controller = Organize::StudyQueuesController.new
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

    assert_not_nil assigns(:study_queues)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:study_queue)
    assert assigns(:study_queue).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:study_queue)
  end

  def test_create
    num_study_queues = StudyQueue.count

    post :create, :study_queue => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_study_queues + 1, StudyQueue.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:study_queue)
    assert assigns(:study_queue).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil StudyQueue.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      StudyQueue.find(1)
    }
  end
end
