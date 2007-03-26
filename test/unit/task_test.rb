require File.dirname(__FILE__) + '/../test_helper'

class TaskTest < Test::Unit::TestCase
#  fixtures :tasks

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  
  def test_status
    task = Task.find(:first)
    task.status_id = nil
    puts task.current_state
    assert task.current_state =='undefined'

    task.current_state = CurrentStatus::NEW
    assert task.status_id==CurrentStatus::NEW
    assert task.is_allowed_state(CurrentStatus::ACCEPTED)
    assert task.is_allowed_state(CurrentStatus::REJECTED)
    assert task.is_new

    task.current_state = CurrentStatus::REJECTED
    assert task.status_id==CurrentStatus::REJECTED
    assert task.is_allowed_state(CurrentStatus::ACCEPTED)
    assert task.has_failed

    task.current_state = CurrentStatus::ACCEPTED
    assert task.status_id==CurrentStatus::ACCEPTED

    assert task.is_status(CurrentStatus::ACCEPTED)
    assert task.is_status('accepted')
    assert task.is_status([1,2,3])
    assert task.allowed_status_list.size>1
    assert task.is_allowed_state(CurrentStatus::COMPLETED)
    assert task.is_allowed_state(CurrentStatus::WAITING)
    assert task.is_allowed_state(CurrentStatus::PROCESSING)
    assert task.is_allowed_state(CurrentStatus::ABORTED)
    assert task.is_allowed_state(CurrentStatus::REJECTED)  

    task.current_state = 'waiting'
    assert task.status_id==CurrentStatus::WAITING
    assert task.is_allowed_state(CurrentStatus::COMPLETED)
    assert task.is_allowed_state(CurrentStatus::PROCESSING)
    assert task.is_allowed_state(CurrentStatus::ABORTED)
    assert !task.is_allowed_state(CurrentStatus::REJECTED)  # can only abort now 

    task.current_state = CurrentStatus::PROCESSING
    assert task.status_id==CurrentStatus::PROCESSING
    assert task.is_status('processing')
    assert task.is_active

    assert task.is_allowed_state(CurrentStatus::COMPLETED)
    assert task.is_allowed_state(CurrentStatus::WAITING)
    assert task.is_allowed_state(CurrentStatus::PROCESSING)
    assert task.is_allowed_state(CurrentStatus::ABORTED)
    assert task.is_allowed_state(CurrentStatus::VALIDATION)
    assert !task.is_allowed_state(CurrentStatus::REJECTED)  # can only abort now    
   
     ## cant reset for accepted only active
    task.current_state = CurrentStatus::ACCEPTED
    assert task.status_id==CurrentStatus::PROCESSING

    task.current_state = CurrentStatus::REJECTED ## cant reject a active task!
    assert task.status_id==CurrentStatus::PROCESSING

    task.current_state = CurrentStatus::VALIDATION
    assert task.status_id==CurrentStatus::VALIDATION
    assert task.is_allowed_state(CurrentStatus::COMPLETED)
    assert task.is_allowed_state(CurrentStatus::WAITING)
    assert task.is_allowed_state(CurrentStatus::PROCESSING)
    assert !task.is_allowed_state(CurrentStatus::REJECTED)
    assert task.is_allowed_state(CurrentStatus::ABORTED)

    task.current_state = CurrentStatus::COMPLETED
    puts task.current_state
    puts task.status_id
    puts task.allowed_status_list
    
    assert task.status_id==CurrentStatus::COMPLETED
    assert task.is_status(CurrentStatus::COMPLETED)
    assert task.is_status('completed')
    assert task.is_status([1,2,3,4,5])
    assert task.allowed_status_list.size==1
  end
  
end
