require File.dirname(__FILE__) + '/../test_helper'
require 'help_controller'

# Re-raise errors caught by the controller.
class HelpController; def rescue_action(e) raise e end; end

class HelpControllerTest < BiorailsTestCase
  def setup
    @controller = HelpController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_index
    get :index
    assert_response :redirect
  end

  def test_get_uml
    get :uml,nil,@session
    assert_response :success
  end

  def test_get_diagram
    get :diagram,{:id=>'Task'},@session
    #assert_response :success
  end
  
  def test_get_report
    report = Report.find(:first)
    assert report, 'No report to use in test'
    get :report,{:id=> report.id},@session
    #assert_response :success
  end
#
# @todo rjs need to add rake takes to generate documentation 1st 
#
#  def test_get_model
#    get :model,{:id=> 'Task'},@session
#    assert_response :success
#  end

#  def test_get_controller
#    get :controller,{:id=> 'TaskController'},@session
#    assert_response :success
#  end
  
  
end
