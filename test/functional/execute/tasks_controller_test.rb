require File.dirname(__FILE__) + '/../../test_helper'
require 'execute/tasks_controller'

# Re-raise errors caught by the controller.
class Execute::TasksController; def rescue_action(e) raise e end; end

class Execute::TasksControllerTest < Test::Unit::TestCase
  fixtures :tasks
  fixtures :users
  fixtures :projects
  fixtures :roles
  fixtures :memberships
  fixtures :role_permissions

  def setup
    @controller = Execute::TasksController.new
    @request    = ActionController::TestRequest.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @response   = ActionController::TestResponse.new
    @first = Task.find(:first)
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

    assert_not_nil assigns(:tasks)
  end

  def test_show
    get :show, :id => @first.id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:task)
    assert assigns(:task).valid?
  end

  def test_new
    get :new, :id => @first.experiment.id

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:task)
  end

  def test_create
    num_tasks = Task.count

    post :create, :task => {"experiment_id"=>"14", "done_hours"=>"0", "ended_at"=>"2007-02-17",
     "name"=>"TH001-3", "started_at"=>"2007-02-11", "expected_hours"=>"1", "assigned_to"=>"rshell",
     "protocol_version_id"=>"125","study_protocol_id"=>"44", "description"=>"", "status_id"=>"1",
      "is_milestone"=>"false"}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_tasks + 1, Task.count
  end

  def test_edit
    get :edit, :id => @first.id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:task)
    assert assigns(:task).valid?
  end

  def test_update
    post :update, :id => @first.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Task.find(1)

    post :destroy, :id => @first.id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Task.find(1)
    }
  end
  
  def test_grid
    task = Task.find(:first)
    definition = task.process.contexts[0]
    parameter = definition.parameters[1]
    
    context = task.new_context(definition)
    item1 = context.add_task_item(parameter,'10.0')
    item2 = context.item(parameter)
    
    assert !item1.nil
    assert item1==item2
  end
end
