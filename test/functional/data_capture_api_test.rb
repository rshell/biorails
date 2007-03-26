require File.dirname(__FILE__) + '/../test_helper'
require 'data_capture_controller'

class DataCaptureController; def rescue_action(e) raise e end; end

class DataCaptureControllerApiTest < Test::Unit::TestCase
  def setup
    @controller = DataCaptureController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
end
