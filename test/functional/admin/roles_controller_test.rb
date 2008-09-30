require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/admin/roles_controller"

# Re-raise errors caught by the controller.
class Admin::RolesController; def rescue_action(e) raise e end; end

class Admin::RolesControllerTest < Test::Unit::TestCase
 
  def setup
    @controller = Admin::RolesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @user_role = UserRole.find(:first)
    @project_role = ProjectRole.find(:first)
  end

  def test_truth
    assert_not_nil @controller
    assert_not_nil @request
    assert_not_nil @response
    assert_not_nil @project_role
    assert_not_nil @user_role
  end

  def test_index
    get :index, "controller"=>"admin/roles" 
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list
    assert_response :success
    assert_template 'list'
  end

  def test_show_user_role
    get :show, :id => @user_role.id
    assert_response :success
    assert_template 'show'
  end

  def test_show_project_role
    get :show, :id => @project_role.id
    assert_response :success
    assert_template 'show'
  end

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
  end

  def test_create_user_role_failed
    num = Role.count
    post :create, :role => {},:role_type=>'UserRole'
    assert_response :success
    assert_template 'new'
  end

  def test_create_project_role_failed
    num = Role.count
    post :create, :role => {}
    assert_response :success
    assert_template 'new'
  end

  def test_create_user_role_ok
    num = Role.count
    post :create, :role => {:name=>'test-user-role',:description=>'xx'},:role_type=>'UserRole'
    assert_response :redirect
  end

  def test_create_project_role_ok
    num = Role.count
    post :create, :role => {:name=>'test-project-role',:description=>'xx'},:role_type=>'ProjectRole'
    assert_response :redirect
  end

  def test_create_and_destroy_role_ok
    post :create, :role => {:name=>'test-project-role',:description=>'xx'},:role_type=>'ProjectRole'
    assert_response :redirect
    role = Role.find_by_name('test-project-role')
    assert role
    post :destroy,:id=>role.id
    assert_response :redirect
    assert !Role.exists?(role.id)    
  end

  def test_update_project_role_failed
    post :update,"allowed"=>{}, 
      "commit"=>"Save", "action"=>"update", 
      "role"=>{"name"=>nil, "description"=>"Project owner with full rights"}, 
      "id"=>"5", "controller"=>"admin/roles"
    assert_response :success
    assert_template 'edit'
  end

  def test_update_project_role_ok
    post :update,"allowed"=>{
      "teams"=>{"new"=>"true", "list"=>"true", "edit"=>"true", "create"=>"true", 
                "show"=>"true", "update"=>"true"}, 
      "assays"=>{"new"=>"true", "list"=>"true", "edit"=>"true", "destroy"=>"true", "create"=>"true", 
                  "show"=>"true", "update"=>"true", "*"=>"true"}, 
      "experiments"=>{"new"=>"true", "list"=>"true", "edit"=>"true", "destroy"=>"true", "create"=>"true", 
                      "show"=>"true", "update"=>"true", "*"=>"true"}, 
      "project"=>{"new"=>"true", "list"=>"true", "edit"=>"true", "destroy"=>"true", "create"=>"true", 
                  "show"=>"true", "update"=>"true", "*"=>"true"}, 
      "assay_parameters"=>{"new"=>"true", "list"=>"true", "edit"=>"true", "destroy"=>"true", "create"=>"true", 
                           "show"=>"true", "update"=>"true", "*"=>"true"}, 
      "assay_queues"=>{"new"=>"true", "list"=>"true", "edit"=>"true", "destroy"=>"true", "create"=>"true", 
                       "show"=>"true", "update"=>"true", "*"=>"true"}, 
      "tasks"=>{"new"=>"true", "list"=>"true", "edit"=>"true", "make_flexible"=>"true", "create"=>"true", 
                "show"=>"true", "update"=>"true", "*"=>"true"}, 
      "queue_items"=>{"new"=>"true", "list"=>"true", "edit"=>"true", "destroy"=>"true", "create"=>"true", 
                      "show"=>"true", "update"=>"true", "*"=>"true"}, 
      "requests"=>{"new"=>"true", "list"=>"true", "edit"=>"true", "destroy"=>"true", "create"=>"true", 
                    "show"=>"true", "update"=>"true", "*"=>"true"}, 
      "assay_protocols"=>{"new"=>"true", "list"=>"true", "withdraw"=>"true", "edit"=>"true", 
                          "destroy"=>"true", "create"=>"true", "release"=>"true", "show"=>"true", 
                          "update"=>"true", "copy"=>"true", "*"=>"true"}}, 
      "commit"=>"Save", "action"=>"update", 
      "role"=>{"name"=>"Team-Manager", "description"=>"Project owner with full rights"}, 
      "id"=>"5", "controller"=>"admin/roles"
    assert_response :redirect
  end

  def test_edit_project_role
    get :edit, :id => @project_role.id
    assert_response :success
    assert_template 'edit'
  end

  def test_edit_user_role
    get :edit, :id => @user_role.id
    assert_response :success
    assert_template 'edit'
  end

  def test_update_project_role
    post :update,:id => @project_role.id, "allowed"=>{"teams"=>{"list"=>"true", "show"=>"true"}, "assays"=>{"list"=>"true", "show"=>"true"},
      "experiments"=>{"list"=>"true", "show"=>"true"}, "project"=>{"list"=>"true", "show"=>"true"}, 
      "assay_parameters"=>{"list"=>"true", "show"=>"true"}, 
      "assay_queues"=>{"list"=>"true", "show"=>"true"}, 
      "tasks"=>{"list"=>"true", "show"=>"true"}, 
      "queue_items"=>{"list"=>"true", "show"=>"true"}, 
      "requests"=>{"list"=>"true", "show"=>"true"}, 
      "assay_protocols"=>{"list"=>"true", "show"=>"true"}}, 
      "commit"=>"Save", "action"=>"update", 
    "role"=>{"name"=>"Role-2", "description"=>"moose"}, 
    "controller"=>"admin/roles"
    assert_response :redirect
  end

  

end
