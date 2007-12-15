require File.dirname(__FILE__) + '/../test_helper'

class RequestTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :requests

  def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = Request
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
  
  def create_request
    request = Request.new(:name =>'test2',:description=>'test1')
    request.data_element = DataElement.find(1)
    request.requested_by='test'
    rerequest.quest.expected_at='2/2/2020'
    request.status ='new'
    request.priority = 'normal'
    request.save
    queue = StudyQueue.find(6)
    request.add_service(queue)
    cmpd1 = Compound.find(1)
    cmpd2 = Compound.find(2)
    request.add_item(cmpd1)
    request.add_item(cmpd2)
    assert request.save
  end
  
  
  def create_request1
    data_element = DataElement.find(1)
    request = Request.create( {:name =>'test2',:description=>'test1',:data_element_id=>1} )

    request = Request.create( {:name =>'test2',:description=>'test1',:data_element_id=>1} )
    request.requested_by='test'
    rerequest.quest.expected_at='2/2/2020'
    request.status ='new'
    request.priority = 'normal'

  end
end
