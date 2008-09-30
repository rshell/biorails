require File.dirname(__FILE__) + '/../test_helper'
require 'biorails_controller'

# Re-raise errors caught by the controller.
class BiorailsController; def rescue_action(e) raise e end; end

class BiorailsControllerTest < Test::Unit::TestCase
  def setup
    @controller = BiorailsController.new
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
    assert_not_nil api.login('rshell','y90125')  
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
  
  def test_project_list_no_session    
       api.project_list(nil)
      flunk("should have failed with no session")
  rescue
  end  
  
  def test_project_element_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.project_element_list(key,ProjectFolder.find(2))    
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
    list = api.folder_element_list(key,ProjectFolder.find(2))    
    assert_not_nil list
    assert list.is_a?(Array)
  end  

  def test_folder_element_list_invalid
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.folder_element_list(key,0)    
    assert_not_nil list
    flunk("should have failed with no session")
  rescue
  end  

  def test_folder_element_exception
    list = api.folder_element_list(nil,0)    
    assert_nil list
    flunk("should have failed with no session")
  rescue
  end  
  
  def test_project_folder_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.project_folder_list(key,Project.find(2))    
    assert_not_nil list
    assert list.is_a?(Array)
  end  

  def test_project_folder_list_invalid
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.project_folder_list(key,0)    
    assert_not_nil list
    flunk("should have failed with no session")
  rescue
  end  

  def test_project_folder_list_exception
    api.project_folder_list(nil,0)    
    flunk("should have failed with no session")
  rescue
  end  

  def test_assay_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.assay_list(key,Assay.find(:first))    
    assert_not_nil list
    assert list.is_a?(Array)
  end  

  def test_assay_protocol_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.assay_protocol_list(key,AssayProtocol.find(:first))    
    assert_not_nil list
    assert list.is_a?(Array)
  end  
  
  def test_assay_protocol_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.assay_protocol_list(key,AssayProtocol.find(:first))    
    assert_not_nil list
    assert list.is_a?(Array)
  end  
  
  def test_assay_process_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.assay_protocol_list(key,AssayProcess.find(:first))    
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
  
  def test_protocol_version_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.protocol_version_list(key,AssayProtocol.find(:first))    
    assert_not_nil list
    assert list.is_a?(Array)
    assert list.size>0
  end  
  
  def test_protocol_version_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.protocol_version_list(key,AssayProtocol.find(:first))    
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
    assert list.is_a?(Array)
    assert list.size>0
  end  

  def test_process_steps_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.process_steps_list(key,ProcessFlow.find(:first))    
    assert_not_nil list
    assert list.is_a?(Array)
  end  
  
  def test_process_steps_list_invalid
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.process_steps_list(key,0)    
    assert_not_nil list
    assert list.is_a?(Array)
  end  
  
  def test_process_steps_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    flow = ProcessFlow.find(10)
    list = api.process_steps_list(key,flow.id)    
    assert_not_nil list
    assert list.is_a?(Array)
  end  
  
  def test_process_steps_list_invalid
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.process_steps_list(key,0)    
    assert_not_nil list
    assert list.is_a?(Array)
    assert_equal list,[]
  end  
  
  def test_parameter_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.parameter_list(key,ProcessInstance.find(:first),nil)    
    assert_not_nil list
    assert list.is_a?(Array)
  end  
  
  def test_parameter_list_invalid
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.parameter_list(key,0,nil)    
    assert_not_nil list
    assert list.is_a?(Array)
  end  
  
  def test_parameter_context_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.parameter_context_list(key,ProcessInstance.find(:first))    
    assert_not_nil list
    assert list.is_a?(Array)
  end  
  
  def test_parameter_context_list_invalid
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.parameter_context_list(key,0)    
    assert_not_nil list
    assert list.is_a?(Array)
  end  
  
  def test_experiment_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.experiment_list(key,Assay.find(:first).id)    
    assert_not_nil list
    assert list.is_a?(Array)
  end  
  
  def test_experiment_list_invalid
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.experiment_list(key,0)    
    assert_not_nil list
    assert list.is_a?(Array)
  end  
  
  def test_task_mine_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.task_mine_list(key)    
    assert_not_nil list
    assert list.is_a?(Array)
  end  

  def test_task_mine_list_invalid
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.task_mine_list(0)    
    assert_nil list
  end  

  def test_task_context_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.task_context_list(key,2)    
    assert_not_nil list
    assert list.is_a?(Array)
  end  

  def test_task_context_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.task_context_list(key,0)    
    assert_not_nil list
    assert list.is_a?(Array)
  end  

  def test_task_value_list_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.task_value_list(key,Task.find(2))    
    assert_not_nil list
    assert list.is_a?(Array)
  end  
  
  def test_task_value_list_by_context_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    task = Task.find(2)
    context = task.process.contexts[0]
    list = api.task_value_list_by_context(key,2,context.id)    
    assert_not_nil list
    assert list.is_a?(Array)
  end  
  
  def test_get_content_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.get_content(key,ProjectContent.find(:first))    
    assert_not_nil list
    assert list.is_a?(BiorailsApi::Content)
  end  
  
  def test_get_asset_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.get_asset(key,ProjectAsset.find(:first))    
    assert_not_nil list
    assert list.is_a?(BiorailsApi::Asset)
  end  

  def test_get_project_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.get_project(key,Project.find(:first).id)    
    assert_not_nil list
    assert list.is_a?(Project)
  end  

  def test_get_assay_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.get_assay(key,Assay.find(:first).id)    
    assert_not_nil list
    assert list.is_a?(Assay)
  end  

  def test_get_assay_protocol_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.get_assay_protocol(key,AssayProtocol.find(:first).id)    
    assert_not_nil list
    assert list.is_a?(AssayProtocol)
  end  

  def test_get_protocol_version_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.get_protocol_version(key,ProtocolVersion.find(:first).id)    
    assert_not_nil list
    assert list.is_a?(ProtocolVersion)
  end  

  def test_get_experiment_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.get_experiment(key,Experiment.find(:first).id)    
    assert_not_nil list
    assert list.is_a?(Experiment)
  end  

  def test_get_task_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.get_task(key,Task.find(:first).id)    
    assert_not_nil list
    assert list.is_a?(Task)
  end  

  def test_get_task_xml_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.get_task_xml(key,Task.find(:first).id)    
    assert_not_nil list
    assert list.is_a?(String)
  end  

  def test_get_assay_xml_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.get_assay_xml(key,Assay.find(:first).id)    
    assert_not_nil list
    assert list.is_a?(String)
  end  

  def test_get_choices_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    list = api.get_choices(key,DataElement.find(:first).id,'A')    
    assert_not_nil list
    assert list.is_a?(Array)
  end  

  def test_get_report_ok
    assert_not_nil  key = api.login('rshell','y90125')  
    report = Report.find(:first)
    list = api.get_report(key,report.id,1)   
    assert list    
  rescue 
      return nil
  end  

  
  # Replace this with your real tests.
  def test_read_assay
    key = api.login('rshell','y90125')  
    assert !key.nil?, "not got a session key"
    projects = api.project_list(key)
    assays = api.assay_list(key,2)    
    protocols = api.assay_protocol_list(key,assays[0].id)
    processes = api.protocol_version_list(key,protocols[0].id)
    contexts = api.parameter_context_list(key,processes[0].id)
    parameters = api.parameter_list(key,processes[0].id,nil)
    parameters = api.parameter_list(key,processes[0].id,contexts[0].id)
    
    assert assays[0].is_a?(Assay)
    assert protocols[0].is_a?(AssayProtocol)
    assert processes[0].is_a?(ProtocolVersion)
    assert parameters[0].is_a?(Parameter)
  end


  # Replace this with your real tests.
  def test_read_experiment
    key = api.login('rshell','y90125')  
    assert !key.nil?, "not got a session key"
    projects = api.project_list(key)
    assays = api.assay_list(key,2)    
    experiments = api.experiment_list(key,assays[0].id)
    tasks = api.task_list(key,experiments[0].id)
    task_contexts = api.task_context_list(key,tasks[0].id)
    task_values = api.task_value_list(key,tasks[0].id)
    
    assert assays[0].class == Assay
    assert experiments[0].class == Experiment
    assert tasks[0].class == Task
    assert task_contexts[0].class == TaskContext
    assert task_values
   end
  
 def test_export_import_task
    key = api.login('rshell','y90125')  
    assert !key.nil?, "not got a session key"
    projects = api.project_list(key)
    assert projects.size >0
    
    assays = api.assay_list(key,2)    
    assert assays.size >0
    
    experiments = api.experiment_list(key,1)
    assert experiments.size >0

    tasks = api.task_list(key,experiments[0].id)
    assert tasks.size >0

    csv = api.task_export(key,tasks[0].id)
    assert csv.size >0

    task = api.task_import(key,experiments[0].id,csv)
    assert task.class == Task
 end   

 def test_add_experiment
    key = api.login('rshell','y90125')  
    assert !key.nil?, "not got a session key"
    projects = api.project_list(key)
    assert projects.size >0
    
    assays = api.assay_list(key,2)    
    assert assays.size >0

    experiments = api.experiment_list(key,1)
    expt = experiments[0]
    experiment = api.add_experiment(key,expt.project_id,expt.protocol_version_id,"testxxs","testdddd")
    assert experiment
    assert experiment.name=='testxxs'
 end   

 
 def test_add_project
    key = api.login('rshell','y90125')  
    assert !key.nil?, "not got a session key"
    project = api.add_project(key,'x-test','testing',1 )
    assert_ok project
    assert_equal project.class, Project
    assert_equal 'x-test', project.name
 end  

 def test_next_identifier
   name = api.next_identifier('Assay')
   assert_not_nil name
   assert name.class,String
   name2 = api.next_identifier('Assay')
   assert_not_equal name,name2
 end
 
 def test_add_task
    key = api.login('rshell','y90125')  
    assert !key.nil?, "not got a session key"
    old_task = Task.find(:first)
    task = api.add_task(key,old_task.experiment_id,old_task.protocol_version_id,'x-test' )
    assert_ok task
    assert_equal 'x-test', task.name
 end  

 def test_add_task_context
    key = api.login('rshell','y90125')  
    assert !key.nil?, "not got a session key"
    task = Task.find(:first)
    context = api.add_task_context(key, task.id, task.process.roots[0].id )
    assert_ok context
 end  
 
 def test_set_task_value
    key = api.login('rshell','y90125')  
    assert !key.nil?, "not got a session key"
    item = TaskValue.find(:first)
    struct = api.set_task_value(key, item.task_context_id, item.parameter_id,'666')
    assert struct
    assert struct.value 
 end  
 
 def test_set_content
    key = api.login('rshell','y90125')  
    assert !key.nil?, "not got a session key"
    item = ProjectContent.find(:first)
    struct = api.set_content(key, item.parent_id,'test-xxx','test-xxx','<b>test</b>')
    assert struct
    assert_equal 'test-xxx', struct.name
    assert_equal 'test-xxx', struct.title
    assert struct.data
 end  

 def test_set_asset
    key = api.login('rshell','y90125')  
    assert !key.nil?, "not got a session key"
    item = ProjectFolder.find(:first)
    body = Base64.encode64('Test Data')
    struct = api.set_asset(key, item.id,'test.upload','test.txt','text/plain',body)
    assert struct
    assert_equal 'test.txt', struct.name
    assert_equal body, struct.base64
    assert_equal 'test.upload', struct.title
 end  
 
end
