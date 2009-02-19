require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/admin/system_settings_controller"
# Re-raise errors caught by the controller.
class Admin::SystemSettingsController; def rescue_action(e) raise e end; end

class Admin::SystemSettingsControllerTest < BiorailsTestCase

	def setup
		@controller = Admin::SystemSettingsController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
        @request.session[:current_project_id] = 1
        @request.session[:current_user_id] = 3
       
  end

  def test_list_system_settings
    get :list
    assert :success
    assert_template 'list'
    assert_not_nil assigns["system_settings"]
    assert_tag :content => /The site name may be displayed by your template across the top of the page/
  end

  def test_index_system_settings
    get :index
    assert :success
    assert_template 'list'
    assert_not_nil assigns["system_settings"]
    assert_tag :content => /The site name may be displayed by your template across the top of the page/
  end
  
  def test_update_system_settings
    post :update, :id=>'app_title', :app_title=>'new'
    assert :success
    assert_template nil
  end
  
   def test_list_does_not_store_nil_as_value
     post :update, :id=>'welcome_text', :name=>''
     assert :success
     assert_equal '?', @response.body
   end
end