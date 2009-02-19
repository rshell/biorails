require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/execute/tasks_controller"

# Re-raise errors caught by the controller.
class Execute::TasksController; def rescue_action(e) raise e end; end

class Execute::TasksControllerTest < BiorailsTestCase

  def setup
    @controller = Execute::TasksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @first = Task.find(:first)
    @request.session[:current_element_id] =@first.project_element_id
    @request.session[:current_project_id] = @first.project_id
    @request.session[:current_user_id] = 3  
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
  end

  def test_show
    get :show, :id => @first.id
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:task)
    assert assigns(:task).valid?
  end

  def test_recalc
    get :recalc, :id => @first.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first.id,:tab=>2
  end

  def test_show_invalid
    get :show, :id => 24242432
    assert_response :success
    assert_template  'access_denied'
  end

  def test_show_granted_via_admin_flag
    User.current = User.find(3)
    Project.current = Project.find(3)
    Project.current.tasks
    @request.session[:current_project_id] =Project.current.id
    @request.session[:current_user_id] = User.current.id
    assert !Project.current.owner?(User.current)
    assert  Task.load(2)
    get :show, :id => 2
    assert_response :success
    assert_template 'show'
  end

  def test_show_denied_for_normal_user
    User.current = User.find(9)
    Project.current = Project.find(3)
    Project.current.tasks
    @request.session[:current_project_id] =Project.current.id
    @request.session[:current_user_id] = User.current.id
    assert !Project.current.owner?(User.current)
    assert_nil Task.load(2)
    get :show, :id => 2
    assert_response :success
    assert_template  'access_denied'
  end

  def test_assign
    get :assign, :id => @first.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
    assert_not_nil assigns(:task)
    assert assigns(:task).valid?
  end

  def test_update_queue
    get :update_queue, :id => @first.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
    assert_not_nil assigns(:task)
    assert assigns(:task).valid?
  end

  def test_make_flexible
    get :make_flexible, :id => @first.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
    assert_not_nil assigns(:task)
    assert assigns(:task).valid?
  end

  def test_update_queue_all
    get :update_queue, :id => @first.id, :any => 'y'
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
    assert_not_nil assigns(:task)
    assert assigns(:task).valid?
  end

 def test_import_file
    get :import_file, :id=>1, :file=>'file'
    assert_response :success
    assert_template 'import'
     assert_nil assigns(:task)
  end

  def test_import_file_ie6_pattern
    get :import_file, :id=>1, 'File'=>'file'
    assert_response :success
    assert_template 'import'
     assert_nil assigns(:task)
  end
  
  def test_import_file_fails_because_file_param_missing
     post :import_file, :id=>1
     assert_response :success
     assert_template 'import'
     assert_nil assigns(:task)
   end

  def test_import_file_invalid_file
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','test-parameters.csv'))
    post :import_file, :id=>1,:file=>file
     assert_response :success
     assert_template 'import'
     assert_nil assigns(:task)
  end
  
  def test_import_file_good_file
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','Experiment1-Task1.csv'))
    post :import_file, :id=>1,:file=>file
     assert_response :redirect
     assert_redirected_to :action => 'show', :id => 1
     assert_not_nil assigns(:task)
  end
  
  def test_metrics
    get :metrics, :id => @first.id
    assert_response :success
    assert_template 'metrics'
    assert_not_nil assigns(:task)
    assert assigns(:task).valid?
  end

  def test_print
    get :print, :id => @first.id
    assert_response :success
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
    get :import, :id => @first.id
    assert_response :success
    assert_not_nil assigns(:task)
    assert assigns(:task).valid?
  end

# @TODO cleaning up analysis methods

  def test_analysis_none
    @first.process.analysis_method = nil
    @first.process.save
    get :analysis, :id => @first.id
    assert_response :success
    assert_template 'analysis'#

    assert_not_nil assigns(:task)
    assert_nil assigns(:analysis)
    assert_not_nil assigns(:level0)
    assert_not_nil assigns(:level1)
    assert assigns(:task).valid?
  end

  def test_analysis_ok
    @first.process.analysis_method_id = 1
    @first.process.save
    get :analysis, :id => @first.id
    assert_response :success
    assert_template 'analysis'#

    assert_not_nil assigns(:task)
    assert_not_nil assigns(:analysis)
    assert_not_nil assigns(:level0)
    assert_not_nil assigns(:level1)
    assert_ok assigns(:analysis)
    assert_ok assigns(:task)
  end

  def test_analysis_run
    @first.process.analysis_method_id = 1
    @first.process.save
    get :analysis, :id => @first.id,:run=>'yes'
    assert_response :success
    assert_template 'analysis'

    assert_not_nil assigns(:task)
    assert_not_nil assigns(:level0)
    assert_not_nil assigns(:level1)
    assert_ok assigns(:analysis)
    assert_ok assigns(:task)
  end

  def test_analysis_run_ajax
    @first.process.analysis_method_id = 1
    @first.process.save
    get :analysis, :id => @first.id,:run=>'yes',:format=>'js'
    assert_response :success
    assert_template '_analysis'

    assert_not_nil assigns(:task)
    assert_not_nil assigns(:level0)
    assert_not_nil assigns(:level1)
    assert_ok assigns(:analysis)
    assert_ok assigns(:task)
  end
  
  def test_folder
    get :folder, :id => @first.id
    assert_response :success
    assert_not_nil assigns(:task)
    assert_not_nil assigns(:project_folder)
    assert assigns(:task).valid?
  end

  def test_report
    get :report, :id => @first.id
    assert_response :success
    assert_not_nil assigns(:task)
    assert assigns(:task).valid?
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

  def test_cell_value_with_error
    get :cell_value, :id=>-1 ,:label=>'Concentration[5]', :field=>'parameter_12',:row=>5, :column=>6,:value=>0.811 , :originalValue=>1 
    assert_response :success
  end
    
  def test_cell_value_numeric_failed_as_completed
    get :cell_value, :id=>15 ,:label=>'Concentration[5]', :field=>'parameter_12',:row=>5, :column=>6,:value=>0.811 , :originalValue=>1 
    assert_response :success
    assert_not_nil assigns(:context)
    assert assigns(:context).valid?

  end
  
  def test_cell_value_numeric
    row = TaskContext.find(15)
    task = row.task
    assert task.save    
    get :cell_value, :id=>row.id ,:label=>'Concentration[5]', :field=>'parameter_12',:row=>5, :column=>6,:value=>"15.00" , :originalValue=>1
    assert_response :success
    assert_not_nil assigns(:context)
    assert assigns(:context).valid?
    assert assigns(:item)
    assert assigns(:item)[:value],  assigns(:item)
    assert assigns(:item)[:passed], assigns(:item)
    row.reload
    task.reload
    item = row.item(Parameter.find(12))
    assert_equal "15 %",item.to_unit.to_s
  end
  
  def test_cell_value_text
    row = TaskContext.find(17)
    task = row.task
    assert task.save    
    get :cell_value, :id=>row.id ,:label=>'context0[0]', :field=>'parameter_9',:row=>5, :column=>6,:value=>"xxxx" , :originalValue=>1 
    assert_response :success
    assert_not_nil assigns(:context)
    assert assigns(:context).valid?
    row.reload
    task.reload
    item = row.item(Parameter.find(9))
    assert_equal "xxxx",item.to_s
  end

  def test_cell_value_reference_failed
    row = TaskContext.find(10)
    task = row.task
    assert task.save    
    get :cell_value, :id=>row.id ,:label=>'context0', :field=>'parameter_6',:row=>0, :column=>1,:value=>"xxxx" , :originalValue=>1 
    assert_response :success
    assert_not_nil assigns(:context)
    assert assigns(:context).valid?
    row.reload
    task.reload
    item = row.item(Parameter.find(6))
    assert item.new_record?, item.to_xml
  end
  
  
  def test_cell_value_delete
    row = TaskContext.find(15)
    task = row.task
    assert task.save    
    get :cell_value, :id=>row.id ,:label=>'Concentration[5]', :field=>'parameter_12',:row=>5, :column=>6,:value=>'' , :originalValue=>1 
    assert_response :success
    assert_not_nil assigns(:context)
    assert assigns(:context).valid?
    row.reload
    task.reload
    item = row.item(Parameter.find(12))
    assert item.new_record?
  end
  

  def test_cell_value_quantity
    row = TaskContext.find(15)
    task = row.task

    assert task.save    
    get :cell_value, :id=>15 ,:label=>'Concentration[5]', :field=>'parameter_12',:row=>5, :column=>6,:value=>'0.811 mM' , :originalValue=>1 
    assert_response :success
    assert_not_nil assigns(:context)
    assert assigns(:context).valid?
    row.reload
    task.reload
    item = row.item(Parameter.find(12))
    assert "0.811 mM",item.to_s

  end
  
  def test_new
    get :new, :id => @first.experiment.id
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:task)
  end

  def test_create_failed
    num_tasks = Task.count
    post :create, :task => {}
    assert_response :success
    assert_template 'new'
    assert_equal num_tasks , Task.count
  end
  
  def test_create_failed_for_duplicate_name
    duplicate=Task.find(:first).name
    post :create, :task=>{:experiment_id=>"1", :name=>duplicate, :protocol_version_id=>"1", :expected_at=>"2008-04-16", "assigned_to_user_id"=>"3", :description=>"", :status_id=>"0", :started_at=>"2008-04-15"}
    assert_not_nil assigns(:task)
    assert !assigns(:task).valid?
    assert assigns(:task).errors
    assert assigns(:task).errors[:name]
  end
    
  def test_create_succeeded
    num_tasks = Task.count
    post :create, :task=>{:experiment_id=>"1", :name=>"Task-90", :protocol_version_id=>"1", :expected_at=>"2008-04-16", "assigned_to_user_id"=>"3", :description=>" Task in experiment Task-89 ", :status_id=>"0", :started_at=>"2008-04-15"}
    assert_equal num_tasks+1 , Task.count
    assert_equal 'Task was successfully created.', flash[:notice]
  end

  def test_copy
    get :copy, :id => @first.id
    assert_response :redirect
    assert_redirected_to :action => 'show'
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
  
  def test_update_should_fail_for_no_name
    post :update, :id => @first.id, :task=>{:name=>''}
    assert_response :success
    assert_not_nil assigns(:task)
    assert !assigns(:task).valid?
    assert assigns(:task).errors
    assert assigns(:task).errors[:name]
  end
  
  
  def test_list_columns
    post :list_columns, :id => @first.id
    assert_response :success
  end
  
  def test_add_column_failed
    param = AssayParameter.find(9)
    post :add_column, :id => 2,:name=>param.name
    assert_response :redirect
    assert_ok assigns(:task)
    assert_redirected_to :action => 'show', :id => 3,:tab=>3    
  end

  def test_add_column_invalid_id_ajax
    param = AssayParameter.find(9)
    post :add_column, :id => 223232,:name=>param.name,:format=>'js'
    assert_response :success
    assert !assigns(:successful)
  end

  def test_add_column_ok
    param = AssayParameter.find(9)
    task =Task.find(2)
    task.make_flexible
    task.save
    task.reload
    assert task.flexible?
    num = task.process.parameters.size
    post :add_column, :id => task.contexts[0].id,:name=>param.name
    assert_ok assigns(:task)
    assert_equal num+1,task.process.parameters.size
    assert_response :redirect
    assert_ok assigns(:task)
    assert_ok assigns(:task_context)
    assert_redirected_to :action => 'show'
  end

  def test_add_column_ok_ajax
    param = AssayParameter.find(9)
    task =Task.find(2)
    task.make_flexible
    task.save
    post :add_column, :id => task.contexts[0].id,:name=>param.name,:format=>'js'
    assert_response :success
    assert_ok assigns(:task)
  end

  def test_add_row
    context = Task.find(2).contexts[0]
    post :add_row, :id => context.id
    assert_response :redirect
    assert_ok assigns(:task)
    assert_redirected_to :action => 'show', :id => 2,:tab=>3    
  end

  def test_add_column_ajax
    param = AssayParameter.find(9)
    post :add_column, :id => 2,:name=>param.name,:format=>'js'
    assert_response :success
    assert_ok assigns(:task)
  end
  
  def test_add_row_ajax
    context = Task.find(2).contexts[0]
    post :add_row, :id => context.id,:format=>'js'
    assert_response :success
    assert_ok assigns(:task)
  end
  
  def test_add_row_ajax_failed
    post :add_row, :id => nil,:format=>'js'
    assert_response :success
  end
  
  def test_destroy
    Task.transaction do
      assert_not_nil @first
      post :destroy, :id => @first.id
      assert_response :redirect
      assert_nil flash[:warning]
      assert_redirected_to :action => 'show'
      assert_raise(ActiveRecord::RecordNotFound) {
        Task.find(@first.id)
      }
   #   raise ActiveRecord::Rollback 
    end
  end

  def test_select_model_element
    get :select, :id => ModelElement.find(1),:query=>'Test'
    assert_response :success
  end

  def test_select_model_element_with_context
    context = Task.find(2).contexts[0]
    get :select, :id => ModelElement.find(1),:query=>'Test',:task_context_id=>context.id
    assert_equal nil,  TaskContext.current
    assert_response :success
  end

  def test_select_list_element
    get :select, :id => ListElement.find(80),:query=>'Dose'
    assert_response :success
  end

  def test_select_list_element_with_context
    context = Task.find(2).contexts[0]
    get :select, :id => ListElement.find(80),:query=>'Dose',:task_context_id=>context.id
    assert_equal nil, TaskContext.current
    assert_response :success
  end

  def test_select_list_element_with_null_context
    get :select, :id => ListElement.find(80),:query=>'Dose',:task_context_id=>nil
    assert_equal nil,  TaskContext.current
    assert_response :success
  end

  def test_select_list_element_with_invalid_context
    get :select, :id => ListElement.find(80),:query=>'Dose',:task_context_id=>32244342
    assert_equal nil,  TaskContext.current
    assert_response :success
  end
end
