require File.dirname(__FILE__) + '/../test_helper'

class DataConceptsTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :data_contexts
  ## Biorails::Dba.import_model :data_concepts

 def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = DataConcept
  end
  
  def test_truth
    assert true
  end
  
  def test_find
     first = @model.find(:first)
     assert first.id
     assert first.name
  end

  def test_elements
     first = DataElement.find(:first).concept
     assert first.elements?
     assert first.name
  end

  def test_children
     first = @model.find(:first)
     assert first.children?
  end

  def test_parameter_types
     first = ParameterType.find(:first,:conditions=>"data_concept_id is not null").data_concept
     assert first.parameter_types?
  end

  def test_leaf
     first = @model.find(:all).last
     assert first.leaf?

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
 
  def test_has_summary
    first = @model.find(:first)
    assert first.summary 
  end

   def test_works_for_child
    first = @model.find(:first,:conditions=>'parent_id is not null')
    assert first.summary 
    assert first.path
    xml = first.to_xml
    other = DataConcept.from_xml(xml)
    assert_equal first,other
  end

  def test_xml_round_trip
    first = @model.find(:first)
    xml = first.to_xml
    other = DataConcept.from_xml(xml)
    assert_equal first,other
  end
  
end
