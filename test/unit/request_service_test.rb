require File.dirname(__FILE__) + '/../test_helper'

class RequestServiceTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :request_services

 def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = RequestService
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
