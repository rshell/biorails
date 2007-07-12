require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/parameter_roles_controller'

# Re-raise errors caught by the controller.
class Admin::ParameterRolesController; def rescue_action(e) raise e end; end

class Admin::ParameterRolesControllerTest < Test::Unit::TestCase
  fixtures :parameter_roles

	NEW_PARAMETER_ROLE = {}	# e.g. {:name => 'Test ParameterRole', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = Admin::ParameterRolesController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
		@first = ParameterRole.find_first
	end

  def test_truth
    assert true
  end


end
