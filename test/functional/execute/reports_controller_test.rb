require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/execute/reports_controller"

# Re-raise errors caught by the controller.
class Execute::ReportsController; def rescue_action(e) raise e end; end

class Execute::ReportsControllerTest < Test::Unit::TestCase

  def setup
    @controller = Execute::ReportsController.new
    @request    = ActionController::TestRequest.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @response   = ActionController::TestResponse.new
    @first = Report.find(51)
  end

  def test_setup
    assert_not_nil @controller
    assert_not_nil @request
    assert_not_nil @response
    assert_not_nil @first , "Missing a valid fixture for this controller"
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

    assert_not_nil assigns(:report)
    assert assigns(:report).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:report)
  end

  def test_create_failed
    num_request_services = Report.count

    post :create, :report => {}

    assert_response :success
    assert_template 'new'

    assert_equal num_request_services , Report.count
  end

  def test_edit
    get :edit, :id => @first.id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:report)
    assert assigns(:report).valid?
  end

  def test_update
    post :update, :id => @first.id
    assert_response :success
  end

  def test_destroy
    Report.transaction do
        assert_nothing_raised {
          Report.find(@first.id)
        }

        post :destroy, :id => @first.id
        assert_response :redirect
        assert_redirected_to :action =>'list'

        assert_raise(ActiveRecord::RecordNotFound) {
          Report.find(@first.id)
        }
     #raise ActiveRecord::Rollback 
    end  
  end
end
