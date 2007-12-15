require File.dirname(__FILE__) + '/../test_helper'

class ParameterContextTest < Test::Unit::TestCase
  # Replace this with your real tests.
    def setup
     @model = ParameterContext
  end
  
  def test_truth
    assert true
  end
  
  def test_find
     first = @model.find(:first)
     assert first.id
     assert first.label
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
  
  def test_has_path
    first = @model.find(:first)
    assert first.path    
  end
  
  def test_has_label
    first = @model.find(:first)
    assert first.label    
  end
  
  def test_has_default_count
    first = @model.find(:first)
    assert first.default_count    
  end
  
  def test_has_parameters
    first = @model.find(:first)
    assert first.parameters   
    assert first.parameters.size>0   
  end

  def test_has_process
    first = @model.find(:first)
    assert first.process    
  end  

  def test_has_process
    first = @model.find(:first)
    assert first.process    
  end  
  
  def test_is_related
    first = @model.find(:first,:conditions=>'parent_id is not null')
    assert first.is_related(first)
    assert first.parent
    assert first.is_related(first.parent)    
  end
  
  def test_to_xml
    first = @model.find(:first,:conditions=>'parent_id is not null')
    assert first.to_xml
  end
 
  def test_build_empty_row
    first = @model.find(:first,:conditions=>'parent_id is not null')
    values = first.default_row    
    assert values.size == first.parameters.size    
  end

    def test_default_total_greater_then_zero
    first = @model.find(:first,:conditions=>'parent_id is not null')
    assert first.default_total > 0    
  end

  def test_default_total_greater_then_zero
    first = @model.find(:first,:conditions=>'parent_id is null')
    assert first.default_total > 0    
    assert first.default_total == first.default_count  
  end

  def test_build_empty_block
    first = @model.find(:first,:conditions=>'parent_id is not null')
    block = first.default_block 
    assert block
    assert block.size >0
    assert block.values[0].size > 0
    assert block.values.size == first.default_count    
    assert block.values[0].size == first.parameters.size    
  end
  
  def test_build_default_row_labels
    first = @model.find(:first,:conditions=>'parent_id is not null')
    assert first.label
    labels = first.default_labels
    assert labels 
    assert labels.size > 0 
    assert labels.size == first.default_total   
    assert labels.all?{|i|i.size>0}    
  end
end
