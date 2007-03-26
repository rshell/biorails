require File.dirname(__FILE__) + '/../test_helper'

class DataElementsTest < Test::Unit::TestCase
  fixtures :data_contexts
  fixtures :data_concepts
  fixtures :data_systems
  fixtures :data_elements

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_VodelElement
     cmpd = DataElement.find(1)
     assert cmpd.model == Compound
     assert cmpd.size > 0
     assert cmpd.values.size = cmpd.size
     assert cmpd.choices = cmpd.size     
  end

  def test_SqlElement
     cmpd = DataElement.find(2)
     assert cmpd.model == Compound
     assert cmpd.size > 0
     assert cmpd.values.size = cmpd.size
     assert cmpd.choices = cmpd.size     
  end

  def test_ViewElement
     cmpd = DataElement.find(10)
     assert cmpd.model == DataValue
     assert cmpd.size > 0
     assert cmpd.values.size = cmpd.size
     assert cmpd.choices = cmpd.size     
  end
  
  
end
