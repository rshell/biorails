require File.dirname(__FILE__) + '/../test_helper'

class CompoundTest < Test::Unit::TestCase

 def setup
     @model = Compound
     @item = Compound.find(1)
  end
  
  def test_truth
    assert @item
  end
  
  def test_find
     first = @model.find(:first)
     assert first.id
     assert first.name
  end
  
  def test_new
    first = @model.new
    assert first
    assert first.new_record?
    assert !first.valid?
  end

  def test_update
    first = @model.find(:first)
    assert first.save
    assert !first.new_record?
    assert first.valid?
  end
  
  def test_has_name
    first = @model.find(:first)
    assert first.name    
  end

  def test_has_description
    first = @model.find(:first)
    assert first.description    
  end
 
end

