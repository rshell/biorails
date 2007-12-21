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
     assert_not_nil first.study.id
     assert_not_nil first.protocol.id
     assert_not_nil first.project.id
     assert_not_nil first.process.id
  end
  
  def test_new
    first = @model.new
    assert first
    assert first.new_record?
    assert !first.valid?
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

  def test_has_description
    first = @model.find(:first)
    assert first.description    
  end
 
  def test_export
    expt = @model.find(1)
    task = expt.tasks[0]
    csv = task.to_csv
    task2 =expt.import_task(csv)
    assert task2   
  end
   
  def test_copy
    exp = Experiment.find(:first)
    assert !exp.nil?,"No Experiment fixture found"
    exp2 = exp.copy
    assert exp2   
    assert exp2.tasks.size ==exp.tasks.size
  end
end
