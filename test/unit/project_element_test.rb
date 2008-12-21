require File.dirname(__FILE__) + '/../test_helper'

class ProjectElementTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :project_elements

  def test_new
    item = ProjectElement.new(:name=>'test')
    assert item.name
    assert item.summary  
    assert item.html 
  end
  
  def test_find
     first = ProjectElement.find(:first)
     assert first.id
     assert first.name
     assert_ok first
  end
    
  def test_has_name
    first = ProjectElement.find(:first)
    assert first.name    
  end

   def test_has_summary
    first = ProjectElement.find(:first)
    assert first.summary    
  end

  def test_to_html
    first = ProjectElement.find(:first)
    assert first.to_html
  end

  def test_reference?
    first = ProjectReference.find(:first)
    if first
      assert first.reference?
    end
  end

   def test_icon
    first = ProjectElement.find(:first)
    assert first.icon  
  end

  def test_can_render_as_html
    first = ProjectElement.find(:first)
    assert first.to_html   
  end

  def test_has_style
    first = ProjectElement.find(:first)
    assert first.style   
  end
   
  def test_has_icon
    first = ProjectElement.find(:first)
    assert first.icon
  end

  def test_has_path
    first = ProjectElement.find(:first)
    assert first.path
  end

  def test_signed
    first = ProjectElement.find(2)
    assert first.signed(5)
  end

  def test_sign
    first = ProjectElement.find(2)
    assert first.signatures
  end
  
  def test_reorder_before
    top = ProjectFolder.find(84)
    assert top.elements.size>6
    e0 = top.elements[2]
    e1 = top.elements[5]
    assert e1.reorder_before(e0)
  end
  
  def test_reorder_after
    top =  ProjectFolder.find(84)
    assert top.elements.size>6
    e0 = top.elements[1]
    e1 = top.elements[4]
    assert e0.reorder_after(e1)
  end
  
  def test_rebuild_set
     ProjectElement.rebuild_sets   
     first = ProjectElement.find(1)
     assert_ok first
  end


end
