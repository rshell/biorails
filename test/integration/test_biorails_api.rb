require File.dirname(__FILE__) + '/../test_helper'

class TestBiorailApi < Test::Unit::TestCase
  
  def setup
    @api = ActionWebService::Client::Soap.new(BiorailsApi,"http://localhost:3000/biorails/api")    
  end
  
  def api
    @api 
  end
  
  # Replace this with your real tests.
  def test_read_study
    key = api.login('rshell','y90125')  
    projects = api.project_list(key)
    studies = api.study_list(key,projects[1].id)    
    protocols = api.study_protocol_list(key,studies[0].id)
    processes = api.protocol_version_list(key,protocols[0].id)
    contexts = api.parameter_context_list(key,processes[0].id)
    parameters = api.parameter_list(key,processes[0].id)
    parameters = api.parameter_list(key,processes[0].id,contexts[0].id)
    
    assert studies[0].class == Study
    assert protocols[0].class == StudyProtocol
    assert processes[0].class == ProtocolVersion
    assert parameters[0].class == Parameter
  end


  # Replace this with your real tests.
  def test_read_experiment
    key = api.login('rshell','y90125')  
    projects = api.project_list(key)
    studies = api.study_list(key,projects[1].id)    
    experiments = api.experiment_list(key,studies[0].id)
    tasks = api.task_list(key,experiments[0].id)
    task_contexts = api.task_context_list(key,tasks[0].id)
    task_values = api.task_value_list(key,tasks[0].id)
    
    assert studies[0].class == Study
    assert experiments[0].class == Experiment
    assert tasks[0].class == Task
    assert task_contexts[0].class == TaskContext
    assert task_values
   end
  
 def test_create_task
    key = api.login('rshell','y90125')  
    projects = api.project_list(key)
    assert projects.size >0
    
    studies = api.study_list(key,projects[1].id)    
    assert studies.size >0
    
    experiments = api.experiment_list(key,studies[0].id)
    assert experiments.size >0

    tasks = api.task_list(key,experiments[0].id)
    assert tasks.size >0

    csv = api.task_export(key,tasks[0].id)
    assert cvs.size >0

    task = api.task_import(key,experiments[0].id,csv)
    assert task.class == Task
 end   
end
