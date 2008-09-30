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
    @item = Compound.create(:first)
  end

 
  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list
    assert_response :success
    assert_template 'list'
  end
  
  def test_show
    get :show
    assert_response :success
    assert_template 'show'
  end

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
  end

  def test_edit
    get :edit,:id=>@item.id
    assert_response :success
    assert_template 'edit'
  end

end
