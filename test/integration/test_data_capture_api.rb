class TestDataCaptureApi < Test::Unit::TestCase

  # Replace this with your real tests.
  def test_read_study
    api = ActionWebService::Client::Soap.new(DataCaptureApi,"http://192.168.1.110:3000/data_capture/api")
    
    studies = api.study_list    
    protocols = api.protocol_list(studies[0].id)
    processes = api.process_list(protocols[0].id)
    contexts = api.parameter_context_list(processes[0].id)
    parameters = api.parameter_list(processes[0].id)
    
    assert studies[0].class == Study
    assert protocols[0].class == StudyProtocol
    assert processes[0].class == ProtocolVersion
    assert parameters[0].class == Parameter
  end


  # Replace this with your real tests.
  def test_read_experiment
    api = ActionWebService::Client::Soap.new(DataCaptureApi,"http://localhost:3000/data_capture/api")
    
    studies = api.study_list    
    experiments = api.experiment_list(studies[0].id)
    tasks = api.task_list(experiments[0].id)
    task_contexts = api.task_contexts(tasks[0].id)
    task_values = api.task_values(tasks[0].id)
    
    assert studies[0].class == Study
    assert experiments[0].class == Experiment
    assert tasks[0].class == Task
    assert task_contexts[0].class == Task
   end
  
 def test_create_task
    api = ActionWebService::Client::Soap.new(DataCaptureApi,"http://localhost:3000/data_capture/api")
    
    studies = api.study_list    
    experiments = api.experiment_list(studies[0].id)
    tasks = api.task_list(experiments[0].id)

    csv = api.task_export(tasks[0].id)
    task = api.task_import(experiment[0].id,csv)
    
    assert !task.class = Task
 end   
end
