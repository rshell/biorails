require File.dirname(__FILE__) + '/../test_helper'

class ProjectElementTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :project_elements

  def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = ProjectElement
  end
  
  def test_new
    item = ProjectElement.new(:name=>'test')
    assert item.name
    assert item.summary  
    assert item.description  
    assert item.to_html 
  end
  
  def test_find
     first = @model.find(:first)
     assert first.id
     assert first.name
     assert_ok first
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

  def test_to_html
    first = @model.find(:first)
    assert first.to_html
  end

  def test_reference?
    first = ProjectReference.find(:first)
    if first
      assert first.reference?
    end
  end

   def test_icon
    first = @model.find(:first)
    assert first.icon  
  end

  def test_can_render_as_html
    first = @model.find(:first)
    assert first.to_html   
  end

  def test_has_style
    first = @model.find(:first)
    assert first.style   
  end
   
  def test_has_icon
    first = @model.find(:first)
    assert first.icon
  end

  def test_has_path
    first = @model.find(:first)
    assert first.path
  end

  def test_signed
    first = @model.find(:first)
    assert first.signed(5)
  end

  def test_sign
    first = ProjectElement.find(:first)
    assert first.signatures
  end
  
  def test_reorder_before
    top = Project.find(2).home
    assert top.elements.size>2
    e0 = top.elements[0]
    e1 = top.elements[1]
    assert e1.reorder_before(e0)
  end
  
  def test_reorder_after
    top = Project.find(2).home
    assert top.elements.size>2
    e0 = top.elements[0]
    e1 = top.elements[1]
    assert e0.reorder_after(e1)
  end
  
  def test_rebuild_set
     ProjectElement.rebuild_sets   
     first = @model.find(:first)
     assert_ok first
  end


end
