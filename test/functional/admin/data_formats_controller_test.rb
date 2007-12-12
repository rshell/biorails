require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/admin/data_formats_controller"

# Re-raise errors caught by the controller.
class Admin::DataFormatsController; def rescue_action(e) raise e end; end

class Admin::DataFormatsControllerTest < Test::Unit::TestCase
  # # fixtures :data_formats

	NEW_DATA_FORMAT = {}	# e.g. {:name => 'Test DataFormat', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = Admin::DataFormatsController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
		@first = DataFormat.find_first
	end

  def test_truth
    assert true
  end

end
