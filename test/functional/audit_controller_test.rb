require File.dirname(__FILE__) + '/../test_helper'
require 'audit_controller'

# Re-raise errors caught by the controller.
class AuditController; def rescue_action(e) raise e end; end

class AuditControllerTest < Test::Unit::TestCase
  def setup
    @controller = AuditController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_show
    get :show,{:auditabel_type=>'Project',:id=>'1'},@session    
    assert_response :redirect
  end
  
  def test_show_as_xml
    get :show,{:auditabel_type=>'Project',:id=>'1',:format=>'xml'},@session    
    assert_response :redirect
  end
  
  def test_show_as_json
    get :show,{:auditabel_type=>'Project',:id=>'1',:format=>'json'},@session    
    assert_response :redirect
  end

  def test_show_as_js
    get :show,{:auditabel_type=>'Project',:id=>'1',:format=>'js'},@session    
    assert_response :redirect
  end
  
end
