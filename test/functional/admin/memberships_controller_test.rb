require File.dirname(__FILE__) + '/../../test_helper'
require  "memberships_controller"

# Re-raise errors caught by the controller.
class MembershipsController; def rescue_action(e) raise e end; end

class MembershipsControllerTest < Test::Unit::TestCase
  # fixtures :memberships

  def setup
    @controller = Admin::MembershipsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3

    @item = Membership.find(:first)
    @team = @item.team
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

    assert_not_nil assigns(:memberships)
  end

  def test_show
    get :show, :id => @item.id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:membership)
    assert assigns(:membership).valid?
  end

  def test_new
    get :new, :id => @team.id

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:membership)
  end

  def test_create
    num_memberships = Membership.count
    user = User.find(:first)
    role = UserRole.find(:first)
    team = Team.create(:name=>'qatest',:description=>'test')
    
    post :create,:id=>team.id, :membership => {:team_id=>team.id, :user_id=>user.id, :role_id=>role.id, :owner=>0}

    assert_response :redirect
    assert_equal num_memberships+1, Membership.count
  end
  
  def test_create_without_role
    num_memberships = Membership.count
    user = User.find(:first)
    team = Team.create(:name=>'qatest',:description=>'test')  
    post :create,:id=>team.id, :membership => {:team_id=>team.id, :user_id=>user.id, :owner=>0}
    assert_response :success
     assert_equal num_memberships, Membership.count
  end
  
 
  
  def test_create_without_user
    num_memberships = Membership.count
    role = UserRole.find(:first)
    team = Team.create(:name=>'qatest',:description=>'test')    
    post :create,:id=>team.id, :membership => {:team_id=>team.id, :role_id=>role.id, :owner=>0}
    assert_response :success
     assert_equal num_memberships, Membership.count
  end
  
  def test_edit
    get :edit, :id =>  @item.id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:membership)
    assert assigns(:membership).valid?
  end

  def test_update
    post :update, :id => @item.id
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end

  def test_update_failed
    post :update, :id => @item.id,:membership=>{:role_id=>nil}
    assert_response :success
    assert_template 'edit'
  end

  def test_destroy_allow
    member = Membership.find(9)
    post :destroy, :id =>  member.id
    assert_response :redirect
    assert_redirected_to :action => 'list'
    assert !Membership.exists?(9)
  end

  def test_destroy_deny
    member = Membership.find(1)
    post :destroy, :id =>  member.id
    assert_response :redirect
    assert_redirected_to :action => 'list'
    assert Membership.exists?(1)
  end
end
