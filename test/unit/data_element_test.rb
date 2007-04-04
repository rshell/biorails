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
  
  def test_ModelElement
     cmpd = ModelElement.find(:first)
     assert_not_nil cmpd
     assert cmpd.model == Compound, "cmpd.model=#{cmpd.model}"
#     assert cmpd.values.size > 0,"has values "
  end

  def test_SqlElement
     cmpd = SqlElement.find(:first)
     assert_not_nil cmpd
 #    assert  cmpd.values.size > 0  ,"has values "
  end

  def test_ViewElement
     cmpd = ViewElement.find(:first)
     assert_not_nil cmpd
#     assert  cmpd.values.size ,"has values "
  end
  
  
end
