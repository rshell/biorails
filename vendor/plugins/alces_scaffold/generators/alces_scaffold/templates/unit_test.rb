require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../test_helper'

class <%= class_name %>Test < Test::Unit::TestCase
  fixtures :<%= table_name %>

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_find_first
    asset <%= class_name %>.find(:first)
  end

  def test_find1
    item = <%= class_name %>.find(1)
    asset item 
    asset item.id == 1
  end

  def test_find2
    item = <%= class_name %>.find(2)
    asset item 
    asset item.id == 2
  end
  
  def test_new
    item = <%= class_name %>.new
    asset item 
    asset item.new_record?
  end

  def test_update
    item = <%= class_name %>.find(:first)
    asset item 
    asset item.save
  end

  
end
