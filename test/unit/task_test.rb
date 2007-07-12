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
    assert task
    task.status_id = nil
  end
  
  def test002_status
    task = Task.new(:name=>'test')
    task.status = Alces::ScheduledItem::NEW
    assert task.status_id==Alces::ScheduledItem::NEW 
    assert task.is_allowed_state(Alces::ScheduledItem::ACCEPTED)
    assert task.is_allowed_state(Alces::ScheduledItem::REJECTED)
  end
  
  def test003_status
    task = Task.new(:name=>'test')
    task.status = Alces::ScheduledItem::REJECTED
    assert task.status_id==Alces::ScheduledItem::REJECTED
    assert task.is_allowed_state(Alces::ScheduledItem::NEW)
    assert task.has_failed
  end
  
  def test004_status
    task = Task.new(:name=>'test')
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

  end
  
  def test005_status
    task = Task.new(:name=>'test')
    task.status = 'waiting'
    assert task.status_id==Alces::ScheduledItem::WAITING
    assert task.is_allowed_state(Alces::ScheduledItem::COMPLETED)
    assert task.is_allowed_state(Alces::ScheduledItem::PROCESSING)
    assert task.is_allowed_state(Alces::ScheduledItem::ABORTED)
    assert !task.is_allowed_state(Alces::ScheduledItem::REJECTED)  # can only abort now 

  end
  
  def test006_status
    task = Task.new(:name=>'test')
    task.status = Alces::ScheduledItem::PROCESSING
    assert task.status_id==Alces::ScheduledItem::PROCESSING
    assert task.is_status('processing')
    assert task.is_active

  end
  
  def test007_status
    task = Task.new(:name=>'test')
    task.status = Alces::ScheduledItem::PROCESSING
    assert task.is_allowed_state(Alces::ScheduledItem::COMPLETED)
    assert task.is_allowed_state(Alces::ScheduledItem::WAITING)
    assert task.is_allowed_state(Alces::ScheduledItem::PROCESSING)
    assert task.is_allowed_state(Alces::ScheduledItem::ABORTED)
    assert task.is_allowed_state(Alces::ScheduledItem::VALIDATION)
    assert !task.is_allowed_state(Alces::ScheduledItem::REJECTED)  # can only abort now    

  end
  
  def test008_status
    task = Task.new(:name=>'test')
    task.status = Alces::ScheduledItem::PROCESSING
    task.status = Alces::ScheduledItem::ACCEPTED
    assert task.status_id==Alces::ScheduledItem::ACCEPTED
  end
  
  def test009_status
    task = Task.new(:name=>'test')
    task.status = Alces::ScheduledItem::VALIDATION
    assert task.status_id==Alces::ScheduledItem::VALIDATION
    assert task.is_allowed_state(Alces::ScheduledItem::COMPLETED)
    assert task.is_allowed_state(Alces::ScheduledItem::WAITING)
    assert task.is_allowed_state(Alces::ScheduledItem::PROCESSING)
    assert !task.is_allowed_state(Alces::ScheduledItem::REJECTED)
    assert task.is_allowed_state(Alces::ScheduledItem::ABORTED)
  end
  
  def test010_status
    task = Task.new(:name=>'test')
    task.status = Alces::ScheduledItem::COMPLETED
    
    assert task.status_id==Alces::ScheduledItem::COMPLETED
    assert task.is_status(Alces::ScheduledItem::COMPLETED)
    assert task.is_status('completed')
    assert task.is_status([1,2,3,4,5])
  end
  
end
