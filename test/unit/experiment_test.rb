require File.dirname(__FILE__) + '/../test_helper'

class ExperimentTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :experiments

  # Replace this with your real tests.
 def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = Experiment
  end
  
  def test_truth
    assert true
  end
  
  def test_find
     first = @model.find(:first)
     assert_not_nil first
     assert_not_nil first.id
     assert_not_nil first.name
     assert_not_nil first.assay.id
     assert_not_nil first.project.id
     assert_not_nil first.process.id
  end
  
  def test_new
    first = @model.new
    assert first
    assert first.new_record?
    assert !first.valid?
    assert_equal 1.week, first.period
  end

  def test_update
    first = @model.find(:first)
    assert first.save
    assert !first.new_record?
    assert first.valid?
  end
  
  def test_has_name
    first = @model.find(:first)
    assert first.name
  end

  def test_link_to_process_folder
    first = @model.find(:first)
    assert first.link_to_process_folder
  end

  def test_first_task  
    first = @model.find(:first)
    assert first.first_task
  end

  def test_has_description
    first = @model.find(:first)
    assert first.description    
  end
 
  def test_export
    expt = @model.find(:first)
    task = expt.tasks[0]
    csv = task.to_csv
    task2 =expt.import_task(csv)
    assert task2   
  end

  def test_run_flow
    flow = ProcessFlow.find(:first)
    assert flow.steps.size>0
    assert flow.multistep?
    expt = Experiment.find(2)
    num = expt.tasks.size
    expt.run(flow,Time.now)
    expt.reload
    assert_equal num+flow.steps.size,expt.tasks.size
  end
   
  def test_run_process
    flow = ProcessInstance.find(:first)
    assert flow.parameters.size>0
    expt = Experiment.find(2)
    num = expt.tasks.size
    expt.run(flow,Time.now)
    expt.reload
    assert_equal num+1,expt.tasks.size
  end
   
  def test_copy
    exp = Experiment.find(:first)
    assert !exp.nil?,"No Experiment fixture found"
    exp2 = exp.copy
    assert exp2   
    assert exp2.tasks.size ==exp.tasks.size
  end
  
  def test_import_file_bad_no_experiment_name
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','Experiment1-bad_no_experiment_name.csv'))
    experiment = Experiment.find(1)
    experiment.import_task(file)
    flunk("should have failed to create a experiment")
  rescue
  end
    
  def test_import_file_bad_no_assay_name
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','Experiment1-bad_no_assay_name.csv'))
    experiment = Experiment.find(1)
    task = experiment.import_task(file)
    assert task
    assert_ok task
  end
    
  def test_import_file_bad_no_protocol_name
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','Experiment1-bad_no_protocol_name.csv'))
    experiment = Experiment.find(1)
    experiment.import_task(file)
    flunk("should have failed to create a experiment")
  rescue
  end
    
  def test_import_file_poor_data
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','Experiment1-bad-data.csv'))
    experiment = Experiment.find(1)
    task = experiment.import_task(file)
    assert task
    assert_equal 7, task.errors.size
  end
    
  def test_import_file_bad_context
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','Experiment1-bad-context.csv'))
    experiment = Experiment.find(1)
    task = experiment.import_task(file)
    assert task
    assert_equal 8, task.errors.size
  end
    
  def test_import_file_new_task_good_data
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','Experiment1-good-data.csv'))
    experiment = Experiment.find(1)
    task = experiment.import_task(file)
    assert task
    assert_ok task
  end
    
  def test_import_file_old_task_good_data
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','Experiment1-Task1.csv'))
    experiment = Experiment.find(1)
    task = experiment.import_task(file)
    assert task
    assert_ok task
  end

  def test_is_dictionary
    assert_dictionary_lookup(Experiment)
  end

end
