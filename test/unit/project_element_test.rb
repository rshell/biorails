require File.dirname(__FILE__) + '/../test_helper'

class ProjectElementTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :project_elements

  def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = ProjectElement
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

  def test_has_description
    first = @model.find(:first)
    assert first.description    
  end

   def test_has_summary
    first = @model.find(:first)
    assert first.description    
  end

   def test_has_title
    first = @model.find(:first)
    assert first.title    
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
   
end
