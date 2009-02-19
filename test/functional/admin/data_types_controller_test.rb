require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/admin/data_types_controller"

# Re-raise errors caught by the controller.
class Admin::DataTypesController; def rescue_action(e) raise e end; end

class Admin::DataTypesControllerTest < BiorailsTestCase
    
    # # fixtures :data_types

	NEW_DATA_TYPE = {}	# e.g. {:name => 'Test DataType', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = Admin::DataTypesController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
        @request.session[:current_project_id] = 1
        @request.session[:current_user_id] = 3
		@item = DataType.find(:first)
	end

  def test_truth
    assert true
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
    get :show, :id => @item.id
    assert_response :success
    assert_template 'show'
  end

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
  end

  def test_create_failed
    num = DataType.count
    post :create
    assert_response :success
    assert_template 'new'
    assert_equal num , DataType.count
  end

  def test_create_ok
    num = DataType.count
    post :create, :data_types => {:name=>'video',:description=>'video'}
    assert_response :redirect
    assert_redirected_to :action => 'list'
    assert_equal num+1 , DataType.count
  end
  
  def test_create_duplicate
    num = DataType.count
    post :create, :data_types => {:name=>'video',:description=>'video'}
    assert_response :redirect
    assert_redirected_to :action => 'list'
    assert_equal num+1 , DataType.count
    post :create, :data_types => {:name=>'video',:description=>'video'}
    assert_response :success
    assert_template 'new'
  end
  
  def test_edit
    get :edit, :id => @item.id
    assert_response :success
    assert_template 'edit'
  end

  def test_update
    post :update, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @item.id
  end

  def test_update_failed
    post :update, :id => @item.id,:data_types=>{:name=>nil,:description=>nil}
    assert_response :success
    assert_template 'edit'
  end


  def test_destroy
    assert_not_nil DataType.find(@item.id)
    post :destroy, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end

end
