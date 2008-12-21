require File.dirname(__FILE__) + '/../test_helper'

class TaskTest < Test::Unit::TestCase

  def test_find
     task = Task.find(:first)
     assert task.id
     assert task.name
  end
  
  def test_new
    task = Task.new
    assert task
    assert task.new_record?
    assert !task.valid?
  end

  def test_update
    task = Task.find(:first)
    assert task.save
    assert !task.new_record?
    assert task.valid?
  end
  
  def test_rename
    task = Task.find(:first)
    task.name='xxxtest'
    assert task.save
    assert_ok task
    task.reload
    assert task.name ='xxxtest'
    assert task.folder.name='xxxtest'
  end
  
  def test_create
    task = Task.find(:first)
    folder = task.process.folder
    element = folder.add_content('name','body')
    assert_ok element
    reference = folder.add_reference('example',task)
    assert_ok reference
    
    new_task = Task.new
 
    new_task.experiment = task.experiment
    new_task.process = task.process        
    assert_save_ok new_task
    folder = new_task.folder
    assert_equal 2,folder.elements.size
  end
  
  def test_copy
    task = Task.find(:first)
    folder = task.process.folder
    element = folder.add_content('name','body')
    assert_ok element
    reference = folder.add_reference('example',task)
    assert_ok reference
    folder.reload    
    task.reload
    task.status_id =5    
    new_task = task.copy
    new_task.experiment = task.experiment
    new_task.name= 'xfsfsfs'
    assert_save_ok new_task
    assert_ok new_task
    new_folder = new_task.folder
    assert_ok new_folder  
    new_folder.reload    
    assert_equal folder.elements.size,new_folder.elements.size
  end
  
 
  
  def test_has_name
    task = Task.find(:first)
    assert task.name
  end

  def test_has_assay_name
    task = Task.find(:first)
    assert task.assay_name
  end

  def test_has_description
    task = Task.find(:first)
    assert task.description
  end

  def test_has_experiment
    task = Task.find(:first)
    assert task.experiment
  end
 
  def test_has_process
    task = Task.find(:first)
    assert task.process
  end

  def test_has_project
    task = Task.find(:first)
    assert task.project
  end

  def test_has_period
    task = Task.find(:first)
    assert task.period
  end  
  
  def test_has_started_at
    task = Task.find(:first)
    assert task.started_at
  end

  def test_has_expected_at
    task = Task.find(:first)
    assert task.expected_at
  end

  def test_has_has_contexts
    task = Task.find(:first)
    assert task.contexts
  end  

  def test_has_roots
    task = Task.find(:first)
    assert task.roots    
  end  

  def test_has_elements
    task = Task.find(:first)
    assert task.elements    
  end  

  def test_has_assigned_to 
    task = Task.find(:first)
    assert task.assigned_to   
  end  

  def test_has_has_contexts_matching
    task = Task.find(:first)
    assert task.contexts.matching(task.process.contexts[0])     
  end  

  def test_has_has_values_matching
    task = Task.find(:first)
    assert task.values.matching(task.process.parameters[0])     
  end  
  
  def test_has_has_texts_matching
    task = Task.find(:first)
    assert task.texts.matching(task.process.parameters[0])     
  end  
  
  def test_has_has_references_matching
    task = Task.find(:first)
    assert task.references.matching(task.process.parameters[0])     
  end  
  
  def test_has_has_items
    task = Task.find(:first)
    assert task.items
  end  
  
  def test_has_process_name
    task = Task.find(:first)
    assert task.process_name
  end  

  def test_has_protocol_name
    task = Task.find(:first)
    assert task.protocol_name
  end  
  
  def test_has_experiment_name
    task = Task.find(:first)
    assert task.experiment_name
  end  

  def test_to_titles
    task = Task.find(:first)
    assert task.to_titles.size >0
  end  

  def test_to_matrix
    task = Task.find(:first)
    assert task.to_matrix
  end  

  def test_to_html
    task = Task.find(:first)
    assert task.to_html
  end  

  def test_has_stats
    task = Task.find(:first)
    assert task.stats
  end  

  def test_has_statistics
    task = Task.find(:first)
    assert task.statistics
  end  

  def test_has_rows
    task = Task.find(:first)
    assert task.rows
  end  

  def test_to_csv
    task = Task.find(:first)
    csv = task.to_csv
    assert(csv.is_a?(String), "expected a string")
  end  
  
  def test_populate
    task = Task.find(:first)
    items = task.populate
    assert !items.nil?,"returen null"
    assert items.is_a?(Hash),"should be a array"
    assert items.size>0,"should have items"
  end
  
  def test_done
    task = Task.find(:first)
    assert task.done
  end  

  def test_done_error
    task = Task.find(:first)
    task.expected_hours = nil
    assert task.done
  end  

  def test_queues
    task = Task.find(:first)
    assert task.queues
  end  

  def test_matching
    task = Task.find(:first)
    assert task.contexts.matching(1)
    assert task.contexts.matching('')
    assert task.contexts.matching(task.process.contexts[0])
  end  
  
  def test_to_grid
    task = Task.find(:first)
    assert task.to_grid
  end  

  def test_start_processing
    old_task = Task.find(:first)
    task = old_task.copy(10)

    task.name= 'xfsssfgfsfs'
    task.experiment = old_task.experiment
    task.save
    assert_ok task
    assert task.folder
    assert_equal 0,task.state.level_no
    assert_equal task.folder.state,task.state
    assert task.start_processing

    assert_equal 1,task.folder.state.level_no
    assert !task.start_processing
  end  
  
  def test_analysis
    task = Task.find(:first)
    assert task.analysis
  end  

  def test_milestone?
    task = Task.find(:first)
    assert_equal false, task.milestone?
  end  

  def test_analysis_with_id
    task = Task.find(:first)
    assert task.analysis(1)
  end  

  def test_is_not_validate
    task = Task.new
    assert !task.valid?
    assert task.done
  end  

  def test_has_audit_collection
    task = Task.find(:first)
    assert task.change_log
  end  
  
  def test_has_valid_date_range
    task = Task.find(:first)
    assert task.started_at < task.expected_at
  end
  
  def test_to_hash_task2
    task = Task.find(2)
    definition = task.process.contexts[0]
    assert definition
    rows = task.to_hash(definition)
    assert rows
  end
  
  def test_row
    task = Task.find(2)
    definition = task.process.contexts[0]
    assert definition
    row = task.row('Concentration[1]')
    assert row
    assert row.is_a?(Hash)
    assert_equal 7, row.size
  end
 
  def test_refresh
    task = Task.find(6)
    items = task.refresh
    assert items
  end
 
  
   def test_to_hash_task7
    task = Task.find(7)
    definition = task.process.contexts[0]
    assert definition
    rows = task.to_hash(definition)
    assert rows
  end
 
  
  # Replace this with your real tests.
  def test000_truth
    assert true
  end

end
