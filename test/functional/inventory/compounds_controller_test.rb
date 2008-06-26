require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/inventory/compounds_controller"

# Re-raise errors caught by the controller.
class Inventory::CompoundsController; def rescue_action(e) raise e end; end

class Inventory::CompoundsControllerTest < Test::Unit::TestCase


 def setup
    @controller = Inventory::CompoundsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 2
    @request.session[:current_user_id] = 3
    @item = Compound.create(:name=>'test')
  end

 
  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

end
