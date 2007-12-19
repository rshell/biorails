require File.dirname(__FILE__) + '/../../test_helper'
require 'project/signatures_controller'

# Re-raise errors caught by the controller.
class Project::SignaturesController; def rescue_action(e) raise e end; end

class Project::SignaturesControllerTest < Test::Unit::TestCase
  def setup
    @controller = Project::SignaturesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
