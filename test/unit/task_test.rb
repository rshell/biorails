require File.dirname(__FILE__) + '/../test_helper'

class TaskTest < Test::Unit::TestCase

 def setup
     @model = Task
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
  
  def test_rename
    first = @model.find(:first)
    first.name='xxxtest'
    assert first.save
    assert_ok first
    first.reload
    assert first.name ='xxxtest'
    assert first.folder.name='xxxtest'
  end
  
  def test_create
    task = @model.find(:first)
    folder = task.process.folder
    element = folder.add_content('name','title','body')
    assert_ok element
    reference = folder.add_reference('example',task)
    assert_ok reference
    
    new_task = Task.new
    new_task.experiment = task.experiment
    new_task.process = task.process        
    assert new_task.save
    assert_save_ok new_task
    folder = new_task.folder
    assert_equal 2,folder.elements.size
  end
  
  def test_copy
    task = @model.find(:first)
    folder = task.process.folder
    element = folder.add_content('name','title','body')
    assert_ok element
    reference = folder.add_reference('example',task)
    assert_ok reference
    task.status_id =5    
    new_task = task.copy
    new_task.experiment = task.experiment
    new_task.name= 'xfsfsfs'
    assert_save_ok new_task
    assert_ok new_task
    folder = new_task.folder
    assert_equal 2,folder.elements.size
  end
  
 
  
  def test_has_name
    first = @model.find(:first)
    assert first.name    
  end

  def test_has_assay_name
    first = @model.find(:first)
    assert first.assay_name   
  end

  def test_has_description
    first = @model.find(:first)
    assert first.description    
  end

  def test_has_experiment
    first = @model.find(:first)
    assert first.experiment
  end
 
  def test_has_process
    first = @model.find(:first)
    assert first.process
  end

  def test_has_project
    first = @model.find(:first)
    assert first.project 
  end

  def test_has_period
    first = @model.find(:first)
    assert first.period 
  end  
  
  def test_has_started_at
    first = @model.find(:first)
    assert first.started_at     
  end

  def test_has_expected_at
    first = @model.find(:first)
    assert first.expected_at     
  end

  def test_has_has_contexts
    first = @model.find(:first)
    assert first.contexts     
  end  

  def test_has_roots
    task = @model.find(:first)
    assert task.roots    
  end  

  def test_has_elements
    task = @model.find(:first)
    assert task.elements    
  end  

  def test_has_assigned_to 
    task = @model.find(:first)
    assert task.assigned_to   
  end  

  def test_has_has_contexts_matching
    task = @model.find(:first)
    assert task.contexts.matching(task.process.contexts[0])     
  end  

  def test_has_has_values_matching
    task = @model.find(:first)
    assert task.values.matching(task.process.parameters[0])     
  end  
  
  def test_has_has_texts_matching
    task = @model.find(:first)
    assert task.texts.matching(task.process.parameters[0])     
  end  
  
  def test_has_has_references_matching
    task = @model.find(:first)
    assert task.references.matching(task.process.parameters[0])     
  end  
  
  def test_has_has_items
    first = @model.find(:first)
    assert first.items     
  end  
  
  def test_has_process_name
    first = @model.find(:first)
    assert first.process_name     
  end  

  def test_has_protocol_name
    first = @model.find(:first)
    assert first.protocol_name     
  end  
  
  def test_has_experiment_name
    first = @model.find(:first)
    assert first.experiment_name     
  end  

  def test_to_titles
    first = @model.find(:first)
    assert first.to_titles.size >0  
  end  

  def test_to_matrix
    first = @model.find(:first)
    assert first.to_matrix  
  end  

  def test_to_html
    first = @model.find(:first)
    assert first.to_html
  end  

  def test_has_stats
    first = @model.find(:first)
    assert first.stats
  end  

  def test_has_statistics
    first = @model.find(:first)
    assert first.statistics
  end  

  def test_has_rows
    first = @model.find(:first)
    assert first.rows
  end  

  def test_to_csv
    first = @model.find(:first)
    csv = first.to_csv
    assert(csv.is_a?(String), "expected a string")
  end  
  
  def test_populate
    first = @model.find(:first)
    items = first.populate
    assert !items.nil?,"returen null"
    assert items.is_a?(Hash),"should be a array"
    assert items.size>0,"should have items"
  end
  
  def test_done
    first = @model.find(:first)
    assert first.done
  end  

  def test_done_error
    first = @model.find(:first)
    first.expected_hours = nil
    assert first.done
  end  

  def test_queues
    first = @model.find(:first)
    assert first.queues
  end  

  def test_matching
    first = @model.find(:first)
    assert first.contexts.matching(1)
    assert first.contexts.matching('')
    assert first.contexts.matching(first.process.contexts[0])
  end  
  
  def test_to_grid
    first = @model.find(:first)
    assert first.to_grid
  end  

  def test_start_processing
    first = @model.find(:first)
    first.status_id = Alces::ScheduledItem::NEW
    assert first.start_processing
    assert Alces::ScheduledItem::PROCESSING,first.status_id
    first.status_id = Alces::ScheduledItem::COMPLETED
    assert !first.start_processing
  end  
  
  def test_analysis
    first = @model.find(:first)
    assert first.analysis
  end  

  def test_milestone?
    first = @model.find(:first)
    assert_equal false, first.milestone?
  end  

  def test_analysis_with_id
    first = @model.find(:first)
    assert first.analysis(1)
  end  

  def test_is_not_validate
    task = Task.new
    assert !task.valid?
    assert task.done
  end  

  def test_has_audit_collection
    first = @model.find(:first)
    assert first.change_log
  end  
  
  def test_has_valid_date_range
    first = @model.find(:first)
    assert first.started_at < first.expected_at     
  end
  
  def test_to_hash_task2
    task = @model.find(2)
    definition = task.process.contexts[0]
    assert definition
    rows = task.to_hash(definition)
    assert rows
  end
  
  def test_row
    task = @model.find(2)
    definition = task.process.contexts[0]
    assert definition
    row = task.row('Concentration[1]')
    assert row
    assert row.is_a?(Hash)
    assert_equal 3, row.size
  end
 
  def test_refresh
    task = @model.find(6)
    items = task.refresh
    assert items
  end
 
  
   def test_to_hash_task7
    task = @model.find(7)
    definition = task.process.contexts[0]
    assert definition
    rows = task.to_hash(definition)
    assert rows
  end
 
  
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
