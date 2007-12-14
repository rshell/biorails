require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/execute/tasks_controller"

# Re-raise errors caught by the controller.
class Execute::TasksController; def rescue_action(e) raise e end; end

class Execute::TasksControllerTest < Test::Unit::TestCase
  # # fixtures :tasks
  # # fixtures :users
  # # fixtures :projects
  # # fixtures :roles
  # # fixtures :memberships
  # # fixtures :role_permissions

  def setup
    @controller = Execute::TasksController.new
    @request    = ActionController::TestRequest.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @response   = ActionController::TestResponse.new
    @first = Task.find(:first)
  end

  def test_setup
    assert_not_nil @controller
    assert_not_nil @request
    assert_not_nil @response
    assert_not_nil @first , "Missing a valid fixture for this controller"
    assert_not_nil @first.id
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

  def test_metrics
    get :metrics, :id => @first.id
    assert_response :success
    assert_template 'metrics'
    assert_not_nil assigns(:task)
    assert assigns(:task).valid?
  end

  def test_view
    get :view, :id => @first.id
    assert_response :success
    assert_template 'view'
    assert_not_nil assigns(:task)
    assert assigns(:task).valid?
  end

  def test_sheet
    get :sheet, :id => @first.id
    assert_response :success
    assert_template 'sheet'
    assert_not_nil assigns(:task)
    assert assigns(:task).valid?
  end

  def test_entry
    get :entry, :id => @first.id
    assert_response :success
    assert_template 'entry'
    assert_not_nil assigns(:task)
    assert assigns(:task).valid?
  end

  def test_export
    get :export, :id => @first.id
    assert_response :success
    assert_not_nil assigns(:task)
    assert assigns(:task).valid?
  end

  def test_import
    get :export, :id => @first.id
    assert_response :success
    assert_not_nil assigns(:task)
    assert assigns(:task).valid?
  end

  def test_analysis
    get :analysis, :id => @first.id
    assert_response :success
    assert_template 'analysis'

    assert_not_nil assigns(:task)
    assert_not_nil assigns(:analysis)
    assert_not_nil assigns(:level0)
    assert_not_nil assigns(:level1)
    assert assigns(:task).valid?
  end

  def test_folder
    get :folder, :id => @first.id
    assert_response :success
    assert_not_nil assigns(:task)
    assert_not_nil assigns(:folder)
    assert assigns(:task).valid?
  end

  def test_report
    get :report, :id => @first.id
    assert_response :success
    assert_not_nil assigns(:task)
    assert assigns(:task).valid?
  end

  def test_transform
    get :transform, :id => @first.id
    assert_response :success
    assert_not_nil assigns(:task)
    assert assigns(:task).valid?
  end

  def test_cell_change
    task = Task.find(:first)
    grid = task.grid
    grid.rows[0].cells.each do |cell| 
      get :cell_change, :id => task.id,:element=>cell.dom_id,:value=> cell.value,:format=>'js'
      assert_response :success      
    end      
  end
  
  def test_context
    get :context, :id => ParameterContext.find(:first)
    assert_response :success
    assert_not_nil assigns(:parameter_context)
    assert assigns(:parameter_context).valid?
  end
  
  def test_values
    get :values, :id => TaskContext.find(:first)
    assert_response :success
    assert_not_nil assigns(:task_context)
    assert assigns(:task_context).valid?
  end
  
  def test_new
    get :new, :id => @first.experiment.id
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:task)
  end

  def test_create
    num_tasks = Task.count
    post :create, :task => {}
    assert_response :success
    assert_template 'new'
    assert_equal num_tasks , Task.count
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
    Task.transaction do
      assert_not_nil @first
      post :destroy, :id => @first.id
      assert_response :redirect
      assert_redirected_to :action => 'show'
      assert_raise(ActiveRecord::RecordNotFound) {
        Task.find(@first.id)
      }
   #   raise ActiveRecord::Rollback 
    end
  end
  
end
