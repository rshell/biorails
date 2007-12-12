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
     assert first.id
     assert first.name
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
 
  
  def test_copy
    exp = Experiment.find(:first)
    assert !exp.nil?,"No Experiment fixture found"
    exp2 = exp.copy
    
  end
end
