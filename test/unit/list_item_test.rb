require File.dirname(__FILE__) + '/../test_helper'

class ListItemTest < BiorailsTestCase
  ## Biorails::Dba.import_model :list_items

  # Replace this with your real tests.
 def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = ListItem
  end
  
  def test_truth
    assert true
  end
   
  def test_new
    first = @model.new
    assert first
    assert first.new_record?
    assert !first.valid?
  end

 
end
