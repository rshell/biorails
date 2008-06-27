require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/admin/parameter_roles_controller"

# Re-raise errors caught by the controller.
class Admin::ParameterRolesController; def rescue_action(e) raise e end; end

class Admin::ParameterRolesControllerTest < Test::Unit::TestCase
  # # fixtures :parameter_roles

	NEW_PARAMETER_ROLE = {}	# e.g. {:name => 'Test ParameterRole', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

 def setup
    @controller = Admin::ParameterRolesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @item = ParameterRole.find(:first)
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
    num = ParameterRole.count
    post :create, :data_type => {}
    assert_response :success
    assert_template 'new'
    assert_equal num , ParameterRole.count
  end
  
  
  def test_create_succeeded
    num = ParameterRole.count
    post :create,  :parameter_role=>{:name=>'hello', :description=>'hello2'}
    assert_response :redirect
    assert_redirected_to :action=> 'list'
    assert_equal num+1 , ParameterRole.count
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



  def test_edited_item_is_invalid_because_name_missing
     post :update, :id => @item.id, :parameter_role=>{:name=>nil}
     assert_response :success
     assert_template 'edit'
   end

   def test_edited_item_is_invalid_because_description_missing
     post :update, :id => @item.id, :parameter_role=>{:description=>nil}
     assert_response :success
     assert_template 'edit'
   end

end
