require File.dirname(__FILE__) + '/../test_helper'

class TaskReferenceTest < BiorailsTestCase

def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = TaskReference
  end
  
  def test_truth
    assert true
  end

  
  def test_new
    first = @model.new
    assert first
    assert first.new_record?
    assert !first.valid?
  end

  
end
