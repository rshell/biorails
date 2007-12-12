require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/admin/data_types_controller"

# Re-raise errors caught by the controller.
class Admin::DataTypesController; def rescue_action(e) raise e end; end

class Admin::DataTypesControllerTest < Test::Unit::TestCase
    
    # # fixtures :data_types

	NEW_DATA_TYPE = {}	# e.g. {:name => 'Test DataType', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = Admin::DataTypesController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
		@first = DataType.find_first
	end

  def test_truth
    assert true
  end

end
