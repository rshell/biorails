require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/admin/assay_stages_controller"

# Re-raise errors caught by the controller.
class Admin::AssayStagesController; def rescue_action(e) raise e end; end

class Admin::AssayStagesControllerTest < Test::Unit::TestCase
  # # fixtures :assay_stages
	def setup
		@controller = Admin::AssayStagesController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @item = AssayStage.find(:first)
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
    num = AssayStage.count
    post :create, :assay_stage => {}
    assert_response :success
    assert_template 'new'
    assert_equal num , AssayStage.count
  end

  def test_create_sucess
    num = AssayStage.count
    post :create, :assay_stage => {:name=>'xxxxx',:description=>'xxxxxx'}
    assert_response :redirect
    assert_redirected_to :action => 'list'
    assert_equal num+1 , AssayStage.count
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
  
  def test_update_invalid
    post :update, :id=>@item.id, :assay_stage=>{:name=>"", :description=>"Capturing raw data -ok"}
    assert_response :success
    assert_empty_error_field('assay_stage[name]')
  end

  def test_destroy
    a = AssayStage.create(:name=>'temp3333',:description=>'tests')
    assert_not_nil AssayStage.find(a.id)
    post :destroy, :id => a.id
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end
  	
end
