require File.dirname(__FILE__) + '/../test_helper'
require 'action_web_service'
require 'action_web_service/test_invoke'

class TestBiorailApi < ActionController::IntegrationTest
  
  def setup
    @api = ActionWebService::Client::Soap.new(BiorailsApi,"http://127.0.0.1:3000/biorails/api")    
  end
  
  def api
    @api 
  end
  
  
  # Replace this with your real tests.
  def test_read_assay
    key = api.login('rshell','y90125')  
    assert !key.nil?, "not got a session key"
    projects = api.project_list(key)
    assays = api.assay_list(key,projects[1].id)    
    protocols = api.assay_protocol_list(key,assays[0].id)
    processes = api.protocol_version_list(key,protocols[0].id)
    contexts = api.parameter_context_list(key,processes[0].id)
    parameters = api.parameter_list(key,processes[0].id)
    parameters = api.parameter_list(key,processes[0].id,contexts[0].id)
    
    assert assays[0].class == Assay
    assert protocols[0].class == AssayProtocol
    assert processes[0].class == ProtocolVersion
    assert parameters[0].class == Parameter
  end


  # Replace this with your real tests.
  def test_read_experiment
    key = api.login('rshell','y90125')  
    assert !key.nil?, "not got a session key"
    projects = api.project_list(key)
    assays = api.assay_list(key,projects[1].id)    
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
    
    assays = api.assay_list(key,projects[1].id)    
    assert assays.size >0
    
    experiments = api.experiment_list(key,assays[0].id)
    assert experiments.size >0

    tasks = api.task_list(key,experiments[0].id)
    assert tasks.size >0

    csv = api.task_export(key,tasks[0].id)
    assert csv.size >0

    task = api.task_import(key,experiments[0].id,csv)
    assert task.class == Task
 end   

 def test_create_task
    key = api.login('rshell','y90125')  
    assert !key.nil?, "not got a session key"
    projects = api.project_list(key)
    assert projects.size >0
    
    assays = api.assay_list(key,projects[1].id)    
    assert assays.size >0

    experiments = api.experiment_list(key,assays[0].id)
    expt = experiments[0]
    experiment = api.add_experiment(key,expt.project_id,expt.protocol_version_id,"testxxs","testdddd")
    assert experiment
    assert experiment.name=='testxxs'
    task = api.add_task(key,experiment.id,experiment.protocol_version_id,"taskxx2")
    assert_equal task, "no task returned"
    assert task.name =="taskxx2", "incorrect name"
 end   
 
end
