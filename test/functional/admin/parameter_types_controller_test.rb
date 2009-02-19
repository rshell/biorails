require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/admin/parameter_types_controller"

# Re-raise errors caught by the controller.
class Admin::ParameterTypesController; def rescue_action(e) raise e end; end

class Admin::ParameterTypesControllerTest < BiorailsTestCase

  NEW_PARAMETER_TYPE = {}	# e.g. {:name => 'Test ParameterType', :description => 'Dummy'}
  REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

  def setup
    @controller = Admin::ParameterTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @item = ParameterType.find(:first)
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
    num = ParameterType.count
    post :create, :data_type => {}
    assert_response :success
    assert_template 'new'
    assert_equal num , ParameterType.count
  end
  
  def test_create_succeeded
    num = ParameterType.count
    post :create,  :parameter_type=>{:data_type_id=>2,:name=>'hello', :description=>'hello2'}
    assert_response :redirect
    assert_redirected_to :action=> 'list'
    assert_equal num+1 , ParameterType.count
  end

  def test_edit
    get :edit, :id => @item.id
    assert_response :success
    assert_template 'edit'
  end
  
  def test_edited_item_is_invalid_because_name_missing
    post :update, :id => @item.id, :parameter_type=>{:name=>nil}
    assert_response :success
    assert_template 'edit'
  end
  
  def test_edited_item_is_invalid_because_description_missing
    post :update, :id => @item.id, :parameter_type=>{:description=>nil}
    assert_response :success
    assert_template 'edit'
  end
  

  def test_update
    post :update, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @item.id
  end

  def test_destroy
    assert_not_nil ParameterType.find(@item.id)
    post :destroy, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

   def test_create_and_destroy
    num = ParameterType.count
    post :create,  :parameter_type=>{:data_type_id=>2,:name=>'hello', :description=>'hello2'}
    assert_response :redirect
    assert_redirected_to :action=> 'list'
    assert_equal num+1 , ParameterType.count
    assert_not_nil ParameterType.find(@item.id)   
    post :destroy, :id => ParameterType.find_by_name('hello').id
    assert_response :redirect
    assert_redirected_to :action=> 'list'
    assert_equal num , ParameterType.count
  end

  def test_add_alias_ok
    post :add, :id => @item.id,:parameter_type_alias=>{:name=>'xxxx',:description=>'xxxxx'}
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert assigns(:parameter_type_alias)
    assert assigns(:parameter_type_alias).valid?
  end

  def test_add_alias_add_then_remove
    post :add, :id => @item.id,:parameter_type_alias=>{:name=>'xxxx',:description=>'xxxxx'}
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert assigns(:parameter_type_alias)
    assert assigns(:parameter_type_alias).valid?
    @item.reload
    list = @item.aliases
    assert list
    assert list.size>0   
    post :remove, :id => list[0].id
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

  def test_add_alias_empty_failed
    post :add, :id => @item.id,:parameter_type_alias=>{:name=>nil,:description=>'xxxxx'}
    assert assigns(:parameter_type_alias)
    assert !assigns(:parameter_type_alias).valid?
    assert_response :success
    assert_template 'show'
  end

  def test_add_alias_duplicate_fails
    post :add, :id => @item.id,:parameter_type_alias=>{:name=>'xxxx',:description=>'xxxxx'}
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert assigns(:parameter_type_alias)
    assert assigns(:parameter_type_alias).valid?
    post :add, :id => @item.id,:parameter_type_alias=>{:name=>'xxxx',:description=>'xxxxx'}
    assert_response :success
    assert_template 'show'
    assert assigns(:parameter_type_alias)
    assert !assigns(:parameter_type_alias).valid?
  end
  
  
end
