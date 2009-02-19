require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/organize/parameters_controller"

# Re-raise errors caught by the controller.
class Organize::ParametersController; def rescue_action(e) raise e end; end

class Organize::ParametersControllerTest < BiorailsTestCase

  def setup
    @controller = Organize::ParametersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = User.find(2)
    Project.current = Project.find(2)
    @parameter  = Parameter.find(:first)
    @request.session[:current_project_id] = 2
    @request.session[:current_user_id] = 2
  end

  def test_index
    get :index,:id =>@parameter.process.protocol.assay_id
    assert_response :success
    assert_template 'list'
  end
  
  def test_list
    get :list,:id =>@parameter.process.protocol.assay_id
    assert_response :success
    assert_template 'list'
  end

  def test_show
    get :show, :id => @parameter.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:parameter)
    assert assigns(:parameter).valid?
  end

end
