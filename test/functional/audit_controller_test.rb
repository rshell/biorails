require File.dirname(__FILE__) + '/../test_helper'
require 'audit_controller'

# Re-raise errors caught by the controller.
class AuditController; def rescue_action(e) raise e end; end

class AuditControllerTest < BiorailsTestCase
  def setup
    @controller = AuditController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 2
    @request.session[:current_user_id] = 3
  end
  
  def test_show
    get :show,:auditable_type=>'Assay',:id=>1
    assert_response :success
  end

  def test_show_xml
    get :show,:auditable_type=>'Assay',:id=>1,:format=>'xml'
    assert_response :success
  end

  def test_show_js_post
    post :show, :auditable_type=>'Assay',:id=>1, :format=>'js'
    assert_response :success    
  end

  def test_show_js_get
    get :show, :auditable_type=>'Assay',:id=>1, :format=>'js'
    assert_response :success    
  end
  
end
