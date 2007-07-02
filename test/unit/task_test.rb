require File.dirname(__FILE__) + '/../test_helper'

class TaskTest < Test::Unit::TestCase
  fixtures :projects
  fixtures :studies
  fixtures :study_protocols
  fixtures :study_parameters
  fixtures :protocol_versions
  fixtures :parameters
  fixtures :experiments
  fixtures :experiments
  fixtures :tasks
  fixtures :task_contexts
  fixtures :task_values
  fixtures :task_texts
 
  # Replace this with your real tests.
  def test000_truth
    assert true
  end

  def test001_status
    task = Task.new(:name=>'test')
    task.status_id = nil

    task.status = Alces::ScheduledItem::NEW
    assert task.status_id==Alces::ScheduledItem::NEW 
    assert task.is_allowed_state(Alces::ScheduledItem::ACCEPTED)
    assert task.is_allowed_state(Alces::ScheduledItem::REJECTED)
    assert task.is_new

    task.status = Alces::ScheduledItem::REJECTED
    assert task.status_id==Alces::ScheduledItem::REJECTED
    assert task.is_allowed_state(Alces::ScheduledItem::ACCEPTED)
    assert task.has_failed

    task.status = Alces::ScheduledItem::ACCEPTED
    assert task.status_id==Alces::ScheduledItem::ACCEPTED
    assert task.is_status(Alces::ScheduledItem::ACCEPTED)
    assert task.is_status('accepted')
    assert task.is_status([1,2,3])
    assert task.allowed_status_list.size>1
    assert task.is_allowed_state(Alces::ScheduledItem::COMPLETED)
    assert task.is_allowed_state(Alces::ScheduledItem::WAITING)
    assert task.is_allowed_state(Alces::ScheduledItem::PROCESSING)
    assert task.is_allowed_state(Alces::ScheduledItem::ABORTED)
    assert task.is_allowed_state(Alces::ScheduledItem::REJECTED)  

    task.status = 'waiting'
    assert task.status_id==Alces::ScheduledItem::WAITING
    assert task.is_allowed_state(Alces::ScheduledItem::COMPLETED)
    assert task.is_allowed_state(Alces::ScheduledItem::PROCESSING)
    assert task.is_allowed_state(Alces::ScheduledItem::ABORTED)
    assert !task.is_allowed_state(Alces::ScheduledItem::REJECTED)  # can only abort now 

    task.status = Alces::ScheduledItem::PROCESSING
    assert task.status_id==Alces::ScheduledItem::PROCESSING
    assert task.is_status('processing')
    assert task.is_active

    assert task.is_allowed_state(Alces::ScheduledItem::COMPLETED)
    assert task.is_allowed_state(Alces::ScheduledItem::WAITING)
    assert task.is_allowed_state(Alces::ScheduledItem::PROCESSING)
    assert task.is_allowed_state(Alces::ScheduledItem::ABORTED)
    assert task.is_allowed_state(Alces::ScheduledItem::VALIDATION)
    assert !task.is_allowed_state(Alces::ScheduledItem::REJECTED)  # can only abort now    

     ## cant reset for accepted only active
    task.status = Alces::ScheduledItem::ACCEPTED
    assert task.status_id==Alces::ScheduledItem::PROCESSING

    task.status = Alces::ScheduledItem::REJECTED ## cant reject a active task!
    assert task.status_id==Alces::ScheduledItem::PROCESSING

    task.status = Alces::ScheduledItem::VALIDATION
    assert task.status_id==Alces::ScheduledItem::VALIDATION
    assert task.is_allowed_state(Alces::ScheduledItem::COMPLETED)
    assert task.is_allowed_state(Alces::ScheduledItem::WAITING)
    assert task.is_allowed_state(Alces::ScheduledItem::PROCESSING)
    assert !task.is_allowed_state(Alces::ScheduledItem::REJECTED)
    assert task.is_allowed_state(Alces::ScheduledItem::ABORTED)

    task.status = Alces::ScheduledItem::COMPLETED
    
    assert task.status_id==Alces::ScheduledItem::COMPLETED
    assert task.is_status(Alces::ScheduledItem::COMPLETED)
    assert task.is_status('completed')
    assert task.is_status([1,2,3,4,5])
    assert task.allowed_status_list.size==1
  end
  
end
