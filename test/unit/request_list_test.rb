require File.dirname(__FILE__) + '/../test_helper'

class RequestListTest < BiorailsTestCase
  ## Biorails::Dba.import_model :lists

  # Replace this with your real tests.
 def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = RequestList
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
