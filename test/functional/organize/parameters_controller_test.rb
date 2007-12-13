require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/organize/parameters_controller"

# Re-raise errors caught by the controller.
class Organize::ParametersController; def rescue_action(e) raise e end; end

class Organize::ParametersControllerTest < Test::Unit::TestCase
  # fixtures :parameters

  def setup
    @controller = Organize::ParametersController.new
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
  end

  def test_show
    get :show, :id => 1
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:parameter)
    assert assigns(:parameter).valid?
  end

end
