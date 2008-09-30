require File.dirname(__FILE__) + '/../test_helper'

class DataElementsTest < Test::Unit::TestCase
  
  def test_model_element
    cmpd = ModelElement.find(:first)
    assert_not_nil cmpd
    assert  cmpd.values
    assert  cmpd.size
    cmpd.reference(1)
    assert  cmpd.like('A',10)
    assert_equal cmpd.model.count, cmpd.like('').size
  end
  
  def test_invalid_model_element
    cmpd = ModelElement.find(:first)
    cmpd.name=nil
    # #assert !cmpd.validate
  end
  
  def test_to_array
    cmpd = ModelElement.find_by_name("DataType")
    assert_equal "text, numeric, date, time, dictionary, url, file",cmpd.to_array.join(', ')
    assert_equal "Date", cmpd.lookup("date").description
  end
  
  def test_sql_element
    cmpd = SqlElement.find(:first)
    assert_not_nil cmpd
    assert  cmpd.values
    assert  cmpd.statement
    assert  cmpd.to_array
    assert  cmpd.size     
    assert  cmpd.sql_select
    cmpd.reference(1)
    assert  cmpd.like('A')     
  end

  def test_create_list_element_no_content
    element = ListElement.new
    element.name = 'xxxx'
    element.style = 'list'
    element.description = 'test'
    element.concept = DataConcept.find(:first)
    element.system = DataSystem.find(:first)
    element.content = ""
    assert !element.valid?
  end
  
  def test_create_list_element_text
    element = ListElement.new
    element.name = 'xxxx'
    element.style = 'list'
    element.description = 'test'
    element.concept = DataConcept.find(:first)
    element.system = DataSystem.find(:first)
    element.content = "a,b,c,d"
    assert element.valid?, "not valid #{element.errors.full_messages.to_sentence}" 
    assert  element.save,"failed to save" 
    assert_ok element     
    assert element.path
    assert element.values
    assert element.to_array
    assert element.lookup('a')
    assert element.format('a')
    assert element.lookup('b').path
    assert element.like(nil)
    assert element.like('a')
    assert !element.lookup('z')
    assert_equal element.children.size,4, "wrong number of children #{element.children.size}"
  end


  def test_create_list_element_integer
    element = ListElement.new
    element.name = 'xxx2'
    element.style = 'list'
    element.description = 'test'
    element.concept = DataConcept.find(:first)
    element.system = DataSystem.find(:first)
    element.content = "1,2,3,4,5,6"
    assert element.values
    assert element.to_array
    assert element.valid?, "not valid #{element.errors.full_messages.to_sentence}" 
    assert  element.save,"failed to save"     
    assert_equal element.children.size,6, "wrong number of children #{element.children.size}"
    assert_save_ok element
    child = element.lookup("1")
    assert_equal child,element.reference(child.id)
    assert_equal nil,element.format('moose')
  end

  
  def test_create_model_element
    @assay = Assay.find(:first)
    element = ModelElement.new
    element.name = 'xxx3'
    element.style = 'model'
    element.description = 'test'
    element.concept = DataConcept.find(2)
    element.system = DataSystem.find(:first)
    element.content = "Assay"
    assert element.valid?, "not valid #{element.errors.full_messages.to_sentence}" 
    assert element.save,"failed to save"     
    assert_ok element     
    assert element.lookup(@assay.name)
    assert element.reference(@assay.id)
    assert element.values
    assert element.to_array
    assert !element.lookup('a')
    assert element.like(@assay.name)
    assert element.like(nil)
    assert_equal element.size,Assay.count, "wrong number of Studies"
  end

  def test_create_model_element_invalid_model
    @assay = Assay.find(:first)
    element = ModelElement.new
    element.name = 'xxx3'
    element.style = 'model'
    element.description = 'test'
    element.concept = DataConcept.find(2)
    element.system = DataSystem.find(:first)
    element.content = "Assay"
    assert element.valid?, "not valid #{element.errors.full_messages.to_sentence}" 
    assert element.save,"failed to save"     
    assert_ok element     
    element.content =nil
    assert_equal nil, element.lookup(@assay.name)
    assert_equal nil, element.reference(@assay.id)
    assert_equal [],element.values
    assert_equal [], element.like(@assay.name)
  end

  
  def test_create_sql_element
    @assay = Assay.find(:first)
    element = SqlElement.new
    element.name = 'xxx3'
    element.style = 'sql'
    element.description = 'test'
    element.concept = DataConcept.find(2)
    element.system = DataSystem.find(:first)
    element.content = "select id,name,description from assays"
    assert element.valid?, "not valid #{element.errors.full_messages.to_sentence}" 
    assert element.save,"failed to save"     
    assert_ok element     
    assert element.lookup(@assay.name)
    assert element.reference(@assay.id)
    assert element.values
    assert element.to_array
    assert !element.lookup('a')
    assert element.like(@assay.name)
    assert_equal [], element.like(nil)
    assert_equal element.size.to_i,Assay.count.to_i, "wrong number of Studies"
  end

  def test_create_sql_element_bad_connection
    @assay = Assay.find(:first)
    element = SqlElement.new
    element.name = 'xxx3'
    element.style = 'sql'
    element.description = 'test'
    element.concept = DataConcept.find(2)
    element.system = DataSystem.find(:first)
    element.content = "select id,name,description from assays"
    assert element.valid?, "not valid #{element.errors.full_messages.to_sentence}" 
    assert element.save,"failed to save"
    assert_ok element 
    element.system =nil
    assert_equal nil, element.lookup(@assay.name)
    assert_equal nil, element.reference(@assay.id)
    assert_equal [],element.values
    assert_equal [], element.like(@assay.name)
  end

  
  def test_xml_round_trip
    data = DataElement.find(:first)
    xml = data.to_xml
    data2 = DataElement.from_xml(xml)
    assert_equal data2,data
  end
  
end
