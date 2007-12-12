require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/admin/data_systems_controller"

# Re-raise errors caught by the controller.
class Admin::DataSystemsController; def rescue_action(e) raise e end; end

class Admin::DataSystemsControllerTest < Test::Unit::TestCase
  # # fixtures :data_systems
  
  def setup
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @controller = Admin::DataSystemsController.new(@request,@response,@session)
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
  end

  def test_truth
    assert true
  end

end
