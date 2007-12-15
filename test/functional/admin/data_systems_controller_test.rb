require File.dirname(__FILE__) + '/../../test_helper'
require "data_systems_controller"

# Re-raise errors caught by the controller.
class Admin::DataSystemsController; def rescue_action(e) raise e end; end

class Admin::DataSystemsControllerTest < Test::Unit::TestCase
  # # fixtures :data_systems
  
  def setup
    @controller = Admin::DataSystemsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @session = @request.session || []
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
  end

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
  end

  def test_show
    get :show, :id => 1
    assert_response :success
    assert_template 'show'
  end  
end
