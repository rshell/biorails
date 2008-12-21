require File.dirname(__FILE__) + '/../test_helper'

class RequestServiceTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :request_services

  def test01_new
    first = RequestService.new
    assert first
    assert first.new_record?
    assert !first.valid?
  end

  def test02_find
    req = RequestService.find(:first)
    assert req
    assert req.percent_done
  end
  
  def test03_percent_done
    req = RequestService.find(:first)
    assert req
    assert req.percent_done
  end
  
  def test04_requested_by
    req = RequestService.find(:first)
    assert req
    assert req.requested_by
  end
  
  def test05_assigned_to
    req = RequestService.find(:first)
    assert req
    assert req.assigned_to
  end
  
  def test06_status_summary   
    req = RequestService.find(:first)
    assert req
    assert req.status_summary   
  end
  
  def test07_num_finished
    req = RequestService.find(:first)
    assert req
    assert req.num_finished
  end
  
  def test08_num_active
    req = RequestService.find(:first)
    assert req
    assert req.num_active
  end
  
  def test09_queue
    req = RequestService.find(:first)
    assert req
    assert req.queue
  end
  
  def test10_results
    req = RequestService.find(:first)
    assert req
    assert req.results
  end
  
  def test11_request
    req = RequestService.find(:first)
    assert req
    assert req.request
  end

  def test12_submit
    req = RequestService.find(:first)
    assert req
    assert req.submit
  end
  
 def test13_update_state
    req = RequestService.find(:first)
    assert req
    req.update_state(:status_id=>1,:priority_id=>1,:user_id=>3,:comment=>'test')
    assert req.status_id=1
    assert req.assigned_to_user_id=3
    assert req.priority_id=1
  end

 def test14_state_complete
    req = RequestService.find(:first)
    assert req
    assert req.accept
    assert req.complete
  end

 def test14_state_reject
    req = RequestService.find(:first)
    assert req
    assert req.reject
  end
 
  def test15_matching_project
    list = RequestService.matching(Project.find(2))
    assert_not_nil list
    assert list.is_a?(Array)
  end
 
  def test16_matching_project
    list = RequestService.matching(Project.find(2))
    assert_not_nil list
    assert list.is_a?(Array)
  end
 
  def test17_matching_queue
    list = RequestService.matching(AssayQueue.find(:first))
    assert_not_nil list
    assert list.is_a?(Array)
  end
 
  def test18_matching_user
    list = RequestService.matching(User.find(2))
    assert_not_nil list
    assert list.is_a?(Array)
  end
 
  def test19_matching_project
    list = RequestService.matching(Request.find(:first))
    assert_not_nil list
    assert list.is_a?(Array)
  end

  def test20_matching_project
    list = RequestService.matching("fred")
    assert_not_nil list
    assert list.is_a?(Array)
  end
  
  def test21_is_summitted
    req = RequestService.find(:first)
    assert !req.is_submitted('sfsfsf')
  end
  
end
