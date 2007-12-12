require File.dirname(__FILE__) + '/../test_helper'

class ProjectContentTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :project_contents

  def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = ProjectContent
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
 
end
