require File.dirname(__FILE__) + '/../test_helper'
require 'soap_controller'

# Re-raise errors caught by the controller.
class SoapController; def rescue_action(e) raise e end; end

class SoapControllerTest < Test::Unit::TestCase
  def setup
    @controller = SoapController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @user = User.find(3)
    @project = Project.find(2) 
    @request.session[:current_project_id] = 2
    @request.session[:current_user_id] = 3
  end
  
  def api
    @controller
  end

  def test_version
    v = api.version
    assert v
    assert !v.empty?
  end  
  
  def test_login_ok
    assert_not_nil key = api.login('rshell','y90125')  
    assert_equal "3",key
  end  

  def test_login_failed_password
    assert_nil api.login('rshell','y95')  
  end  

  def test_login_username
    assert_nil api.login('rsll','y90125')  
  end  

  def test_login_empty
    assert_nil api.login(nil,nil)  
  end  

  def test_project_list
    list = api.project_list(2)
    assert_not_nil list
    assert list.is_a?(Array)
  end

  def test_project
    assert_not_nil  key = api.login('rshell','y90125')
    list = api.project(key,2)
    assert_not_nil list
    assert list.is_a?(Project)
  end
  
  def test_assay_parameter_list
    assert_not_nil  key = api.login('rshell','y90125')
    assay = Assay.find(:first)
    list = api.assay_parameter_list(key,assay.id)
    assert_not_nil list
    assert list.is_a?(Array)
    assert list[0].is_a?(AssayParameter)
  end

  def test_assay_process_list
    assert_not_nil  key = api.login('rshell','y90125')
    assay = Assay.find(:first)
    list = api.assay_process_list(key,assay.id)
    assert_not_nil list
    assert list.is_a?(Array)
    assert list[0].is_a?(AssayProcess)
  end

  def test_project_list_no_session    
    api.project_list(nil)
    flunk("should have failed with no session")
  rescue
  end

  def test_project_match_leaf
    assert_not_nil  key = api.login('rshell','y90125')
    list = api.project_element_matching(key,"Project X/assays/%")
    assert_not_nil list
    assert list.is_a?(Array)
  end

  def test_project_match_root
    assert_not_nil  key = api.login('rshell','y90125')
    list = api.project_element_matching(key,"Project %")
    assert_not_nil list
    assert list.is_a?(Array)
  end

  def test_project_search_all
    assert_not_nil  key = api.login('rshell','y90125')
    list = api.project_element_search(key,"Project X","")
    assert_not_nil list
    assert list.is_a?(Array)
  end

  def test_project_search_for_my_tasks
    assert_not_nil  key = api.login('rshell','y90125')
    list = api.project_element_search(key,"Project X","project_elements.reference_type='Task' and project_elements.created_by_user_id = 1")
    assert_not_nil list
    assert list.is_a?(Array)
  end

  def test_project_search_for_my_tasks
    assert_not_nil  key = api.login('rshell','y90125')
    list = api.project_element_search(key,"","project_elements.reference_type='Task' and project_elements.created_by_user_id = 1")
    assert_not_nil list
    assert list.is_a?(Array)
  end

  def test_project_search_for_tasks
    assert_not_nil  key = api.login('rshell','y90125')
    list = api.project_element_search(key,"Project X","project_elements.reference_type='Task'")
    assert_not_nil list
    assert list.is_a?(Array)
  end

  def test_project_search_for_tasks_and_experiments
    assert_not_nil  key = api.login('rshell','y90125')
    list = api.project_element_search(key,"Project X"," project_elements.reference_type in ('Task','Experiment') ")
    assert_not_nil list
    assert list.is_a?(Array)
  end

  def test_project_search_for_tasks_with_status_over_1
    assert_not_nil  key = api.login('rshell','y90125')
    list = api.project_element_search(key,"Project X", "project_elements.reference_type='Task' and project_elements.state_id > 1 ")
    assert_not_nil list
    assert list.is_a?(Array)
  end

  def test_project_element_list_ok
    assert_not_nil  key = api.login('rshell','y90125')
    list = api.project_element_list(key,2)
    assert_not_nil list
    assert list.is_a?(Array)
  end  

  def test_project_element_list_invalid
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.project_element_list(key,0)    
    assert_not_nil list
    flunk("should have failed with no session")
  rescue
  end  
  
  def test_project_element_exception
    api.project_element_list(nil,0)    
    flunk("should have failed with no session")
  rescue
  end  

  def test_folder_element_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    folder = api.project_folder(key,Project.find(1).project_element_id)
    assert_not_nil folder
    assert_instance_of ProjectFolder, folder
  end  


  def test_folder_element_exception
    folder = api.project_folder(nil,0)    
    assert_nil list
    flunk("should have failed with no session")
  rescue
  end  
 
  def test_assay_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.assay_list(key,2)   
    assert_not_nil list
    assert list.is_a?(Array)
  end  

  def test_assay_protocol_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.assay_protocol_list(key,AssayProtocol.find(:first).id)    
    assert_not_nil list
    assert list.is_a?(Array)
  end  
   
  def test_assay_process_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.assay_protocol_list(key,2)    
    assert_not_nil list
    assert list.is_a?(Array)
  end  
  
  def test_assay_workflow_list_invalid
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.assay_workflow_list(key,0)    
    assert_not_nil list
    assert list.is_a?(Array)
  end  
  
  def test_assay_workflow_list_for_assay
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.assay_workflow_list(key,1)    
    assert_not_nil list
    assert list.is_a?(Array)
    assert list.size>0
  end  
  
  def test_process_flow_list_invalid
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.process_flow_list(key,0)    
    flunk("should have failed with no session")
  rescue
  end  

  def test_process_flow_list_for_project
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.process_flow_list(key,2)    
    assert_not_nil list
    assert list.is_a?(Array)
    assert list.size>0
  end  

  def test_process_instance_list_invalid
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.process_instance_list(key,0)    
    assert_not_nil list
    flunk("should have failed with no session")
  rescue
  end  

  def test_process_instance_list_for_project
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.process_instance_list(key,2)    
    assert_not_nil list
    assert_instance_of Array, list
    assert list.size>0
  end  

  def test_experiment_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.experiment_list(key,2)    
    assert_not_nil list
    assert_instance_of Array, list
    assert list.size>0
  end  
  
  def test_experiment_list_invalid
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.experiment_list(key,0)    
    assert_instance_of Array, list
    assert_equal [],list
  end  

  def test_request_list_ok
    req = Request.find(:first)
    assert_not_nil  key = api.login('rshell','y90125')
    list = api.request_list(key,req.project_id)
    assert_not_nil list
    assert_instance_of Array, list
    assert list.size>0
  end

  def test_request_list_invalid
    assert_not_nil  key = api.login('rshell','y90125')
    list = api.request_list(key,0)
    assert_instance_of Array, list
    assert_equal [],list
  end

  def test_assay_success
    assert_not_nil  key = api.login('rshell','y90125')  
    item = api.assay(key,Assay.find(:first).id)    
    assert_not_nil item
    assert_instance_of Assay, item
  end  

  def test_process_instance_success
    assert_not_nil  key = api.login('rshell','y90125')
    item = api.process_instance(key,1)
    assert_not_nil item
    assert_instance_of ProcessInstance, item
  end

  def test_process_instance_create
    assert_not_nil  key = api.login('rshell','y90125')
    assay = Assay.find(:first)
    status = api.process_instance_create(key,assay.id,"xtest","xtest")
    assert_is_biorails_status_success(status)
  end

  #
  # process is always created with a initial parent context so
  # all other contexts are a child of this one
  #
  def test_process_context_create
    assert_not_nil  key = api.login('rshell','y90125')
    assay = Assay.find(:first)
    status = api.process_instance_create(key,assay.id,"xtest","xtest")
    assert_is_biorails_status_success(status)
    process = ProcessInstance.find(status.class_id)
    context = process.roots[0]
    status = api.parameter_context_create(key,context.id,"child",3)
    assert_is_biorails_status_success(status)
  end

  def test_parameter_create
    assert_not_nil  key = api.login('rshell','y90125')
    assay = Assay.find(:first)
    status = api.process_instance_create(key,assay.id,"xtest","xtest")
    assert_is_biorails_status_success(status)
    process = ProcessInstance.find(status.class_id)
    assay_parameter = process.protocol.assay.parameters[0]
    context = process.roots[0]
    status = api.parameter_create(key,context.id,assay_parameter.id)
    assert_is_biorails_status_success(status)
  end

  def test_process_flow_success
    assert_not_nil  key = api.login('rshell','y90125')  
    item = api.process_flow(key,10)    
    assert_not_nil item
    assert_instance_of ProcessFlow,item
  end  

  def test_experiment_success
    assert_not_nil  key = api.login('rshell','y90125')  
    item = api.experiment(key,Experiment.find(:first).id)    
    assert_not_nil item
    assert_instance_of Experiment,item
  end  

  def test_task_success
    assert_not_nil  key = api.login('rshell','y90125')
    task = Task.find(:first)
    task = api.task(key,task.id)
    assert_instance_of Task,task
    assert task.items
    assert task.process
  end

  def test_task_list
    assert_not_nil  key = api.login('rshell','y90125')
    task = Task.find(:first)
    list = api.task(key,task.experiment_id)
    assert list
  end


  def test_data_concept_list_success
    assert_not_nil  key = api.login('rshell','y90125')
    list = api.data_concept_list(key)
    assert_not_nil list
    assert list.is_a?(Array)
  end

  def test_data_element_list_success
    assert_not_nil  key = api.login('rshell','y90125')
    list = api.data_element_list(key,nil)
    assert_not_nil list
    assert list.is_a?(Array)
    list2 = api.data_element_list(key,0)
    assert_equal list.size,list2.size
    list3 = api.data_element_list(key,DataElement.find(:first).data_concept_id)
    assert_not_equal list.size,list3.size
  end


  def test_data_value_list_success
    assert_not_nil  key = api.login('rshell','y90125')
    list = api.data_value_list(key,DataElement.find(:first).id,1000)
    assert_not_nil list
    assert list.is_a?(Array)
  end

  def test_data_value_like_success
    assert_not_nil  key = api.login('rshell','y90125')
    list = api.data_value_like(key,DataElement.find(:first).id,'A')
    assert_not_nil list
    assert list.is_a?(Array)
  end

  
  # Replace this with your real tests.
  def test_assay_success
    key = api.login('rshell','y90125')  
    assert !key.nil?, "not got a session key"
    assay = api.assay(key,2)        
    assert_instance_of Assay,  assay
    assert assay.protocols
    assert assay.parameters
    assert assay.queues
  end

  def test_data_import_definition_list
    key = api.login('rshell','y90125')  
    assert !key.nil?, "not got a session key"
    item1= DataImportDefinition.new(:name=>'test1',:description=>'test1')
    item1.save!
    assert list = api.data_import_definition_list(key)
    assert list
    assert list.size>0    
  end

  def test_data_import_definition_save_new
    key = api.login('rshell','y90125')  
    assert !key.nil?, "not got a session key"
    item1= DataImportDefinition.new(:name=>'test2',:description=>'test2')
    data = SoapApi::BiorailsDataImportDefinition.from_rec(item1)
    assert_equal item1.name, data.name
    assert status = api.data_import_definition_save(key,data)
    assert_is_biorails_status_success status 
    assert item2 = DataImportDefinition.find(status.class_id),"failed to find saved record"
    assert_equal item1.name,item2.name    
  end
  
  def test_data_import_definition_save_update
    key = api.login('rshell','y90125')  
    assert !key.nil?, "not got a session key"
    item1= DataImportDefinition.new(:name=>'test3',:description=>'test3')
    item1.save!
    item1.name="moose"
    data = SoapApi::BiorailsDataImportDefinition.from_rec(item1)
    assert_equal item1.name, data.name
    assert status = api.data_import_definition_save(key,data)
    assert_is_biorails_status_success status   
    assert item2 = DataImportDefinition.find(status.class_id),"failed to find saved record"
    assert_equal item1.name,item2.name    
  end
  #-------------- Create objects -----------------------------------------------------------------------
  def assert_is_biorails_status_success(status)
    assert status
    assert_instance_of SoapApi::BiorailsStatus,  status
    assert_equal [],status.errors
    assert status.class_id
    assert status.class_name
    assert status.ok
  end

  def test_project_create
    key = api.login('rshell','y90125')  
    assert !key.nil?, "not got a session key"
    status = api.project_create(key,'x-test','testing',1 )
    assert_is_biorails_status_success(status)
  end

  def test_experiment_create
    key = api.login('rshell','y90125')  
    assert !key.nil?, "not got a session key"
    projects = api.project_list(key)
    assert projects.size >0
    
    assays = api.assay_list(key,2)    
    assert assays.size >0

    experiments = api.experiment_list(key,2)
    expt = experiments[0]
    status = api.experiment_create(key, expt.project_id, expt.protocol_version_id, "testxxs","testdddd")
    assert_is_biorails_status_success(status)
  end

 def test_task_export_import
    key = api.login('rshell','y90125')
    assert !key.nil?, "not got a session key"
    task_context = TaskContext.find(:first)
    task = task_context.task
    experiment = task.experiment
    csv = api.task_export(key,task.id)
    assert csv.size >0
    status = api.task_import(key,experiment.id,csv)
    assert task.id,status.class_id
    assert Task.to_s,status.class_name
    assert status.ok
 end

  def test_task_import_with_crap_data
    key = api.login('rshell','y90125')
    assert !key.nil?, "not got a session key"
    task_context = TaskContext.find(:first)
    task = task_context.task
    experiment = task.experiment

    status = api.task_import(key,experiment.id,"esjk,safsaf,safsaf,fsa,fsa,fas,\n,,,,,,,\n,,,,,,,\n")
    assert !status.ok
    assert status.errors
    assert status.errors.size>0
 end

  def test_task_create
    assert key = api.login('rshell','y90125')
    old_task = Task.find(:first)
    status = api.task_create(key, old_task.experiment_id, old_task.protocol_version_id,'x-test','x-test' )
    assert_is_biorails_status_success(status)
  end

  def test_task_destroy
    assert key = api.login('rshell','y90125')
    task = Task.find(:first)
    status = api.task_destroy(key, task.id )
    assert_is_biorails_status_success(status)
  end

  def test_task_row_create
    assert key = api.login('rshell','y90125')
    old_task = Task.find(:first)
    status = api.task_create(key, old_task.experiment_id, old_task.protocol_version_id,'x-test','x-test' )
    assert_is_biorails_status_success(status)
    task = Task.find(status.class_id)
    status = api.task_row_create(key, task.id,task.process.contexts[0])
    assert_is_biorails_status_success(status)
  end

  def test_task_row_append
    assert key = api.login('rshell','y90125')
    old_task = Task.find(1)
    status = api.task_create(key, old_task.experiment_id, old_task.protocol_version_id,'x-test','x-test' )
    assert_is_biorails_status_success(status)
    task = Task.find(status.class_id)
    definition = task.process.contexts[0]
    names= ["Concentration", "Length"]
    values = [ "11 mol/m^3","0.3048 m"]
    list =  api.task_row_append(key,task.id, 0, definition.id, names, values)
    assert list
    assert list.size>0
  end


  def test_task_row_update
    assert key = api.login('rshell','y90125')
    old_task = Task.find(1)
    status = api.task_create(key, old_task.experiment_id, old_task.protocol_version_id,'x-test','x-test' )
    assert_is_biorails_status_success(status)
    task = Task.find(status.class_id)
    definition = task.process.contexts[0]
    names= ["Concentration", "Length"]
    values = [ "11 mol/m^3","0.3048 m"]
    list =  api.task_row_append(key,task.id, 0, definition.id, names, values)
    assert list
    assert list.size>0
    task_context_id = list[0].task_context_id
    list =  api.task_row_update(key, task_context_id, names, values)
    assert list
    assert list.size>0
  end

  def test_user_request
    assert key = api.login('rshell','y90125')
    item = Request.find(:first)
    request = api.user_request(key, item.id)
    assert_instance_of Request,  request
    assert_equal item,request

  end


  def test_request_create
    assert key = api.login('rshell','y90125')
    request = Request.find(:first)
    project = request.project
    data = request.data_element
    status = api.request_create(key, project.id, data.id, 'x-test','x-test',(Time.new+1000.hours) )
    assert_is_biorails_status_success(status)
  end

  def test_queue_add_queue
    assert key = api.login('rshell','y90125')
    request = Request.find(:first)
    project = request.project
    data = request.data_element
    status = api.request_create(key, project.id, data.id, 'x-test','x-test',(Time.new+1000.hours) )
    request = Request.find(status.class_id)
    queue = AssayQueue.find(2)
    status = api.request_add_queue(key,request.id,queue.id)
    assert_is_biorails_status_success(status)
  end

  def test_request_add_item
    assert key = api.login('rshell','y90125')
    request = Request.find(:first)
    project = request.project
    data = request.data_element
    status = api.request_create(key, project.id, data.id, 'x-test','x-test',(Time.new+1000.hours) )
    request = Request.find(status.class_id)
    queue = AssayQueue.find(2)
    status = api.request_add_queue(key,request.id,queue.id)
    list = request.data_element.like("")
    status = api.request_add_item(key,request.id,list[0])
    assert_is_biorails_status_success(status)
  end



 
end
