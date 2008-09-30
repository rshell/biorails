require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/organize/queue_items_controller"

# Re-raise errors caught by the controller.
class Organize::QueueItemsController; def rescue_action(e) raise e end; end

class Organize::QueueItemsControllerTest < Test::Unit::TestCase

  def setup
    @controller = Organize::QueueItemsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 2
    @request.session[:current_user_id] = 3
  end
  
  def test_show
    get :show, :id => QueueItem.find(:first).id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:queue_item)
    assert assigns(:queue_item).valid?
  end

  def test_destroy
    get :destroy, :id => QueueItem.find(:first).id
    assert_response :redirect
  end

end
