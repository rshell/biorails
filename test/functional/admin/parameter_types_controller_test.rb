require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/parameter_types_controller'

# Re-raise errors caught by the controller.
class Admin::ParameterTypesController; def rescue_action(e) raise e end; end

class Admin::ParameterTypesControllerTest < Test::Unit::TestCase
  fixtures :parameter_types

	NEW_PARAMETER_TYPE = {}	# e.g. {:name => 'Test ParameterType', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = Admin::ParameterTypesController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
		@first = ParameterType.find_first
	end

  def test_truth
    assert true
  end
  
  end
