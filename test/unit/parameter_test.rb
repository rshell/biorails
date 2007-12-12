require File.dirname(__FILE__) + '/../test_helper'

class ParameterTest < Test::Unit::TestCase

  # Replace this with your real tests.
  def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = Parameter
  end
  
  def test_truth
    assert true
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
  
  def test_has_name
    first = @model.find(:first)
    assert first.name    
  end

  def test_has_description
    first = @model.find(:first)
    assert first.description    
  end

  def test_has_mask
    first = @model.find(:first)
    assert first.mask    
  end
  
  
  def test_has_study
    first = @model.find(:first)
    assert first.study     
  end

  def test_has_protocol
    first = @model.find(:first)
    assert first.protocol    
  end

  def test_has_process
    first = @model.find(:first)
    assert first.process     
  end
  
  def test_has_context
    first = @model.find(:first)
    assert first.context     
  end
  
  def test_generate_method_setter
    first = @model.find(:first)

    first.set('name','xxxx')
    assert first.name.to_s == 'xxxx'    
    
    first.set(:name,'xxxx')
    assert first.name.to_s == 'xxxx'    

  end
  
  def test_has_style
    first = @model.find(:first)
    assert first.style 
  end
  
  def test_has_element
    first = @model.find(:first,:conditions=>'data_element_id is not null')
    assert first.element   
    first = @model.find(:first,:conditions=>'data_element_id is null')
    assert !first.element   
  end

  def test_has_parameter_type
    first = @model.find(:first)
    assert first.type    
  end  

  def test_has_parameter_role
    first = @model.find(:first)
    assert first.role  
  end  

  def test_has_process
    first = @model.find(:first)
    assert first.process    
  end
  
  def test_based_on_study_parameter
    first = @model.find(:first)
    assert first.study_parameter  
  end  
  
  def test_to_xml
    first = @model.find(:first)
    assert first.to_xml    
  end

  def test_to_json
    first = @model.find(:first)
    assert first.to_json    
  end
    
end
