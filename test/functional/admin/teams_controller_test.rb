require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/admin/teams_controller"

# Re-raise errors caught by the controller.
class Admin::TeamsController; def rescue_action(e) raise e end; end

class Admin::TeamsControllerTest < Test::Unit::TestCase
 
  def setup
    @controller = Admin::TeamsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 2
    @request.session[:current_user_id] = 3
    @item = Team.find(:first)
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'index'
  end

  def test_list
    get :list
    assert_response :success
    assert_template 'index'
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
    num = Team.count
    post :create, :team => {}
    assert_response :success
  end

  def test_create_ok
    num = Team.count
    post :create, :team => {:name=>'sdfsfsfs',:description=>'sfsfsfsf'}
    assert_response :redirect
  end

  def test_edit
    get :edit, :id => @item.id
    assert_response :success
    assert_template 'edit'
  end

  def test_grant
    post :grant, :id => @item.id,:owner_type=>'User',:owner_id=>7,:role_id=>1
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

  def test_grant_user
      post :grant, :id => @item.id,:owner_type=>'User',:user_id=>7,:role_id=>1
      assert_response :redirect
      assert_redirected_to :action => 'show'
      post :grant, :id => @item.id,:owner_type=>'User',:user_id=>7,:role_id=>1
      assert_response :redirect
      assert_redirected_to :action => 'show'
  end

  def test_grant_team
    post :grant, :id => @item.id,:owner_type=>'Team',:owner_id=>1,:role_id=>1
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

  def test_add
    post :add, :id => @item.id,:membership=>{:owner=>true,:user_id=>7}
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

  def test_add_and_remove
    user = User.find(2)
    team = user.create_team(:name=>"twefgsdgf",:description=>'dsgfsgds')
    post :add, :id => team.id,:membership=>{:owner=>true,:user_id=>7}
    assert_response :redirect
    assert_redirected_to :action => 'show'
    post :add, :id => team.id,:owner=>false,:user_id=>3
    assert_response :redirect
    assert_redirected_to :action => 'show'
    team.reload
    assert_equal 2,team.memberships.size
    membership = team.memberships[1]
    post :remove, :id => team.id,:membership_id=> membership.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

  def test_grant_deny
    post :grant, :id => @item.id,:owner_type=>'User',:owner_id=>7,:role_id=>1
    assert_response :redirect
    post :deny, :id => @item.id,:owner_type=>'User',:owner_id=>7,:role_id=>1
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

  def test_deny
    post :deny, :id => @item.id,:owner_type=>'User',:owner_id=>7,:role_id=>1
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end
  
  def test_update_ok
    post :update,:id => @item.id, :team => {:description=>'sfsfsfsf'}
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

  def test_update_failed
    post :update,:id => @item.id, :team => {:description=>nil,:name=>nil}
    assert_response :success
    assert_template 'edit'
  end

  
  def test_destroy
    assert_not_nil Team.find(@item.id)
    post :destroy, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end

  def test_destroy_will_kill
    post :destroy, :id => 9
    assert_response :redirect
    assert_redirected_to :action => 'list'
    assert_raise(ActiveRecord::RecordNotFound) {Team.find(9)}
  end
end
