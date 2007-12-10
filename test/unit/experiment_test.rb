require File.dirname(__FILE__) + '/../test_helper'

class ExperimentTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :experiments

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_copy
    exp = Experiment.find(:first)
    assert !exp.nil?,"No Experiment fixture found"
    exp2 = exp.copy
    
  end
end
