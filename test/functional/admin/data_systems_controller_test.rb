require File.dirname(__FILE__) + '/../../test_helper'
require "data_systems_controller"

# Re-raise errors caught by the controller.
class Admin::DataSystemsController; def rescue_action(e) raise e end; end

class Admin::DataSystemsControllerTest < Test::Unit::TestCase
  # # fixtures :data_systems
  
  def setup
    @controller = Admin::DataSystemsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @session = @request.session || []
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @item = DataSystem.find(:first)
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

  def test_show_no_id
    get :show
    assert_response :success
    assert_template 'list'
  end  
  
  def test_export
    get :export, :id => @item.id
    assert_response :success
  end  

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
  end
  
  def test_new_with_id
    get :new,:id=>DataContext.find(:first)
    assert_response :success
    assert_template 'new'
  end
  
  
  def test_create_new_valid_data_system
     num = DataSystem.count
    post :create, :data_system=>{:name=>'test', :adapter=>'local',:test_object=>'assays', :description=>'test'}
    assert_response :redirect
    assert_redirected_to :action=>'list'
    assert_equal num+1, DataSystem.count
    post :destroy,:id=>DataSystem.find_by_name('test').id
    assert_redirected_to :action=>'list'
  end
  
  def test_create_new_invalid_data_system
     num = DataSystem.count
    post :create, :data_system=>{:adapter=>'local',:test_object=>'assays'}
    assert_response :success
    assert_template 'new'
    assert_equal num, DataSystem.count
  end
  

  def test_edit
    get :edit, :id => @item.id
    assert_response :success
    assert_template 'edit'
  end
  
  def test_edited_item_is_invalid_because_name_missing
      post :update, :id => @item.id, :data_system=>{:name=>nil, :adapter=>'local'}
      assert_response :success
      assert_template 'edit'
    end

    def test_edited_item_is_invalid_because_description_missing
      post :update, :id => @item.id, :data_system=>{:description=>nil, :adapter=>'local'}
      assert_response :success
      assert_template 'edit'
    end

  def test_update
    post :update, :id => @item.id, :data_system=>{}
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @item.id
  end

end
