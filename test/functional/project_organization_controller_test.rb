
require File.dirname(__FILE__) + '/../test_helper'
require  "projects_controller"

# Re-raise errors caught by the controller.
class ProjectsController; def rescue_action(e) raise e end; end

class ProjectOrganizationControllerTest < Test::Unit::TestCase

  def setup
    @controller = ProjectsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    User.current = User.find(2)
    @parent = Project.find(1)
    Project.current =@project = Project.find_by_project_type_id(4)
    @project_type = ProjectType.find(4)
    Biorails::Dba.importing=false
  end

 def test_setup
    assert_ok @project
    assert_ok @parent
    assert_ok @project_type
    assert_not_nil @controller
    assert_not_nil @response
    assert_not_nil @request
    assert_not_nil @request.session[:current_user_id]
    assert_not_nil @request.session[:current_project_id]
  end

  def test_new_root
    get :new_root,:project_type_id=>@project_type.id
    assert_response :success
    assert !assigns(:parent)
    assert assigns(:project_list)
    assert assigns(:project)
    assert_equal @project_type, assigns(:project).project_type
  end

  def test_new_current_parent
    get :new,:project_type_id=>@project_type.id
    assert_response :success
    assert assigns(:parent)
    assert assigns(:project_list)
    assert assigns(:project)
    assert_equal @project_type, assigns(:project).project_type
  end


  def test_new_child
    @request.session[:current_project_id] = @parent.id
    get :new,:id=>@parent.id,:project_type_id=>@project_type.id
    assert_response :success
    assert assigns(:parent)
    assert assigns(:project_list)
    assert assigns(:project)
    assert_equal @project_type, assigns(:project).project_type
  end

  def test_create
     post :create,  {"project"=>{"team_id"=>"2", "name"=>"this is anothert new project", "project_type_id"=>@project_type.id,'title'=>'dggsdgsd', "description"=>"test"}}
     assert_response :redirect
     assert_equal 'Project was successfully created.', flash[:notice]
     assert_redirected_to :action => 'show'
   end

  def test_create_child
     post :create,  {"project"=>{"team_id"=>@parent.team_id,"parent_id"=>@parent.id, "name"=>"this is anothert new project", "project_type_id"=>@project_type.id,'title'=>'dggsdgsd', "description"=>"test"}}
     assert_response :redirect
     assert_equal 'Project was successfully created.', flash[:notice]
     assert_redirected_to :action => 'show'
   end

  def test_destroy
    post :destroy ,:id=>@project.id
    assert_response :redirect
    assert_redirected_to :action => 'index'
  end

  def test_create_invalid_get
    get :create
    assert_response :success
    assert assigns(:project_list)
    assert assigns(:project)
  end

  def test_create_invalid
    destory_id_generator(Project)
    post :create,  {"project"=>{"team_id"=>"2","project_type_id"=>@project_type.id,'title'=>'dggsdgsd', "description"=>"test"}}
    assert :success #reloads the existing page
    assert_not_nil assigns(:project)
    assert !assigns(:project).valid?
    assert assigns(:project).errors
    assert assigns(:project).errors[:name]
  end

  def test_create_invalid_child
    destory_id_generator(Project)
    post :create,  {"project"=>{"team_id"=>@parent.team_id,"parent_id"=>@parent.id,'title'=>'dggsdgsd',"project_type_id"=>@project_type.id, "description"=>"test"}}
    assert :success #reloads the existing page
    assert_not_nil assigns(:project)
    assert !assigns(:project).valid?
    assert assigns(:project).errors
    assert assigns(:project).errors[:name]
  end

  def test_show
    get :show ,:id=>@project.id
    assert_response :success
    assert_equal @project,assigns(:project)
  end

  def test_list
    get :list
    assert_response :success
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_get_edit
    get :edit,:id=>@project.id
    assert_response :success
    assert_template 'edit'
    assert_tag :tag=>'input', :attributes=>{:name=>'project[name]'}
  end

end
