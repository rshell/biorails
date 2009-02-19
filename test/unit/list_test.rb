require File.dirname(__FILE__) + '/../test_helper'

class ListTest < BiorailsTestCase
  # ## Biorails::Dba.import_model :lists

  # Replace this with your real tests.
  def setup
    @model = List
  end
  
  def test_truth
    assert true
  end
  
  def test_find
    first = @model.find(:first)
    assert first.id
    assert first.name
  end
    
  def test_has_name
    first = @model.find(:first)
    assert first.name    
  end

  def test_valid
    first = @model.find(:first)
    assert first.valid?   
  end

  def test_update
    first = @model.find(:first)
    assert first.save  
  end

  def test_to_s
    first = @model.find(:first)
    assert !first.to_s.nil?  
  end

  def test_to_json
    first = @model.find(:first)
    assert !first.to_json.nil?  
  end

  def test_to_xml
    first = @model.find(:first)
    assert !first.to_xml.nil?  
  end

  def test_new
    list = List.new(:name=>'xxx1')
    assert list
  end  

  def test_create
    list = List.create(:name=>'xxx1')
    assert list
    assert list.valid?, list.errors.full_messages().join('\n')
  end  

  def test_update
    list = List.find(:first)
    assert list
    list.description ='sdfsfs'
    assert list.save
    assert list.valid?, list.errors.full_messages().join('\n')
  end  
  
  def test_add_hash
    list = List.create(:name=>'xxx1')
    item = list.add({:id=>1,:name=>'hash'})
    assert item
    assert item.valid?, item.errors.full_messages().join('\n')
  end

  def test_reference
    list = List.create(:name=>'x-format2',:description=>'testing',:data_element_id=>1)
    assert list.reference(1)
  end

  def test_lookup
    list = List.create(:name=>'x-format2',:description=>'testing',:data_element_id=>1)
    assert list.lookup("Text")
  end

  def test_add_string
    list = List.create(:name=>'x-format2',:description=>'testing',:data_element_id=>1)
    item = list.add("Text")
    assert item
    assert item.reference(1)
    assert item.lookup("Text")
    assert item.valid?, item.errors.full_messages().join('\n')
  end

  def test_add_fixnum
    list = List.create(:name=>'x-format3',:description=>'testing',:data_element_id=>32)
    item = list.add(2)
    assert item
    assert item.valid?, item.errors.full_messages().join('\n')
  end

  def test_add_list_item
    list_a = List.create(:name=>'x-formata',:description=>'testing',:data_element_id=>32)
    item_a = list_a.add(2)
    assert_ok item_a
    list_b = List.create(:name=>'x-formatb',:description=>'testing',:data_element_id=>32)
    item_b = list_b.add(item_a)
    assert_ok item_b
    assert_equal item_b.data_element,list_b.data_element
    assert_equal item_b.data_type,item_a.data_type
    assert_equal item_b.data_id  ,item_a.data_id
    assert_equal item_b.data_name,item_a.data_name
  end

end
