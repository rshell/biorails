require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/admin/data_formats_controller"

# Re-raise errors caught by the controller.
class Admin::DataFormatsController; def rescue_action(e) raise e end; end

class Admin::DataFormatsControllerTest < Test::Unit::TestCase
  # # fixtures :data_formats

	NEW_DATA_FORMAT = {}	# e.g. {:name => 'Test DataFormat', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = Admin::DataFormatsController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
		@item = DataFormat.find(:first)
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

  def test_test_failed
    format = DataFormat.find_by_data_type_id(2)
    get :test, :id => format.id,:element=>'xxx',:value=>'xxx'
    assert_response :redirect
    assert_redirected_to :action=> 'list'
  end
  
  def test_test
    format = DataFormat.find_by_data_type_id(2)
    get :test, :id => @item.id,:element=>'xxx',:value=>'xxx'
    assert_response :redirect
    assert_redirected_to :action=> 'list'
  end

  def test_test_ajax
    get :test, :id => @item.id,:element=>'xxx',:value=>'xxx',:format=>'js'
    assert_response :success
  end

  def test_test_failed_ajax
    format = DataFormat.find_by_data_type_id(2)
    get :test, :id => format.id,:element=>'xxx',:value=>'xxx',:format=>'js'
    assert_response :success
  end
  
  
  def test_new
    get :new
    assert_response :success
    assert_template 'new'
  end

  def test_create_failed
    num = DataFormat.count
    post :create, :data_format => {}
    assert_response :success
    assert_template 'new'
    assert_equal num , DataFormat.count
  end
  
  def test_create_succeeded
    num = DataFormat.count
    post :create,  :data_format=>{:name=>'hello', :description=>'hello2'}
    assert_response :redirect
    assert_redirected_to :action=> 'list'
    assert_equal num+1 , DataFormat.count
  end
  
  def test_edit
    get :edit, :id => @item.id
    assert_response :success
    assert_template 'edit'
  end
  
  def test_edited_item_is_invalid_because_name_missing
     post :update, :id => @item.id, :data_format=>{:name=>nil}
     assert_response :success
     assert_template 'edit'
   end

   def test_edited_item_is_invalid_because_description_missing
     post :update, :id => @item.id, :data_format=>{:description=>nil}
     assert_response :success
     assert_template 'edit'
   end
   
  def test_update
    post :update, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end

  def test_destroy
    assert_not_nil DataFormat.find(@item.id)
    post :destroy, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end
end
