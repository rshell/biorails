require File.dirname(__FILE__) + '/../test_helper'

class DataElementsTest < Test::Unit::TestCase
  fixtures :data_contexts
  fixtures :data_concepts
  fixtures :data_systems
  fixtures :data_elements
  fixtures :data_formats    # Used as ModelElement
  fixtures :users           # Used as SqlElement
  fixtures :studies         # Used as test_create_model_element

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_ModelElement
     cmpd = ModelElement.find(1)
     assert_not_nil cmpd
     assert cmpd.values.size > 0,"has values "
  end

  def test_SqlElement
     cmpd = SqlElement.find(29)
     assert_not_nil cmpd
 #    assert  cmpd.values.size > 0  ,"has values "
  end

  def test_ViewElement
     cmpd = ViewElement.find(:first)
#     assert_not_nil cmpd
#     assert  cmpd.values.size ,"has values "
  end
  
  def test_create_list_element_text
     element = ListElement.new
     element.name = 'xxxx'
     element.style = 'list'
     element.description = 'test'
     element.concept = DataConcept.find(2)
     element.system = DataSystem.find(:first)
     element.content = "a,b,c,d"
     element.save     
#     assert element.valid? ,"failed to save"
     assert element.children.size==4, "wrong number of children #{element.children.size}"
  end


  def test_create_list_element_integer
     element = ListElement.new
     element.name = 'xxx2'
     element.style = 'list'
     element.description = 'test'
     element.concept = DataConcept.find(2)
     element.system = DataSystem.find(:first)
     element.content = "1,2,3,4,5,6"
     element.save     
#     assert element.valid? ,"failed to save"
     assert element.children.size==6, "wrong number of children #{element.children.size}"
  end
  
  def test_create_model_element
     element = ModelElement.new
     element.name = 'xxx3'
     element.style = 'model'
     element.description = 'test'
     element.concept = DataConcept.find(2)
     element.system = DataSystem.find(:first)
     element.content = "Study"
     element.save     
#     assert element.valid? ,"failed to save"
     assert element.size == Study.count, "wrong number of Studies"
  end
    
end
