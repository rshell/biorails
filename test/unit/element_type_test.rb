require File.dirname(__FILE__) + '/../test_helper'

class ElementTypeTest < ActiveSupport::TestCase

  def setup
    @model = ElementType
    @item = ElementType.find(1)
  end
  # Replace this with your real tests.
  def test00_setup
    assert @model
    assert @item
  end
  
  def test01_find_first
    assert @model.find(:first)
  end

  def test02_find1
    item = @model.find(1)
    assert item 
    assert item.id == 1
    assert item.name == 'html'
    assert_equal item.model,ProjectContent
  end

  def test03_find2
    item = @model.find(2)
    assert item 
    assert item.id == 2
    assert item.name == 'file'
    assert_equal item.model,ProjectAsset
  end
  
  def test04_new
    item = @model.new
    assert item 
    assert item.new_record?
  end

  def test05_update
    item = @model.find(:first)
    assert item 
    item.description='sdssss'
    assert item.save
  end
 
  def test06_not_valid
    item = @model.new(:description=>'')
    assert item 
    assert !item.valid?
    assert item.errors[:name]
    assert item.errors[:description]
  end

  def test07_valid
    item = @model.new
    item.name ="xxxx"
    item.description ='sfsfs '
    item.class_name = 'ProjectElement'
    assert item.valid?
  end

  
  def test08_new_element
    style = @model.find(1)
    item = style.new_element()
    assert item 
    assert !item.valid?
    assert_equal style.class_name,item.class.to_s       
  end   

  #
  # :name
  # :body
  # :reference
  # :file
  #
  def test09_new_element
    folder = ProjectFolder.find(:first)
    style = @model.find(4)
    item = style.new_element(folder,{:name=>'xxxx',:title=>'testing'})
    assert item 
    assert item.valid?
  end   
  
  def test10_all_elements
    folder = ProjectFolder.find(:first)
    styles = @model.find(:all)
    for style in styles
      item = style.new_element(folder,{:name=>"xxxx=#{style.name}"})
      assert item 
    end
  end
  
  def test11_lookup_by_symbol
    asset = ElementType.find(4)
    item = ElementType.lookup(:folder)
    assert item
    assert_equal item,asset    
  end

  def test12_lookup_by_id
    asset = ElementType.find(2)
    item = ElementType.lookup(2)
    assert item
    assert_equal item,asset    
  end

  def test13_lookup_by_string
    asset = ElementType.find(4)
    item = ElementType.lookup('folder')
    assert item
    assert_equal item,asset    
  end

  def test14_lookup_by_self
    asset = ElementType.find(2)
    item = ElementType.lookup(asset)
    assert item
    assert_equal item,asset    
  end
  
  def test15_lookup_defaults
    assert ElementType.lookup(ElementType::HTML)
    assert ElementType.lookup(ElementType::FILE)
    assert ElementType.lookup(ElementType::REFERENCE)
    assert ElementType.lookup(ElementType::FOLDER)
  end
end

