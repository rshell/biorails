require File.dirname(__FILE__) + '/../test_helper'

class AssayQueueTest < BiorailsTestCase
  ## Biorails::Dba.import_model :assay_queues

  # Replace this with your real tests.
  def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = AssayQueue
  end
  
  def test_truth
    assert true
  end
  
  def test01_find
     first = @model.find(:first)
     assert first.id
     assert first.name
  end
  
  def test02_new
    first = @model.new
    assert first
    assert first.new_record?
    assert !first.valid?
    assert_equal 0, first.percent_done
  end

  def test03_update
    first = @model.find(:first)
    assert first.save
    assert !first.new_record?
    assert first.valid?
  end
  
  def test04_has_name
    first = @model.find(:first)
    assert first.name    
  end

  def test05_has_description
    first = @model.find(:first)
    assert first.description    
  end

  def test06_path  
    first = @model.find(:first)
    assert first.path    
  end
  
  def test07_status_counts
    first = @model.find(:first)
    assert first.status_counts
  end
  
  def test08_data_element 
    first = @model.find(:first)
    assert first.data_element
  end
  
  def test09_priority_counts
    first = @model.find(:first)
    assert first.priority_counts   
  end
  
  def test10_num_active 
    first = @model.find(:first)
    assert first.num_active    
  end
  
  def test11_num_finished
    first = @model.find(:first)
    assert first.num_finished
  end
  
  def test12_percent_done
    first = @model.find(:first)
    assert first.percent_done
  end
  
  def test13_status_summary   
    first = @model.find(:first)
    assert first.status_summary   
  end
  
  def test14_to_xml
    first = @model.find(:first)
    assert first.to_xml
  end

  def test15_from_xml
    first = @model.find(:first)
    xml = first.to_xml
    second = AssayQueue.from_xml(xml)
    assert_equal second.name,first.name
  end
  
    def test16_update
    first = @model.find(:first)
    assert first.save
    assert !first.new_record?
    assert first.valid?
  end

end
