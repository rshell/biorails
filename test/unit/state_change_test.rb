require File.dirname(__FILE__) + '/../test_helper'

class StateChangeTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_create
    assert_ok one= State.create(:name=>'x1',:description=>'new',:level=>1,:is_default=>true,:position=>1)
    assert_ok two= State.create(:name=>'x2',:description=>'accepting',:level=>2,:position=>2)
    assert_ok three= State.create(:name=>'x3',:description=>'processing',:level=>3,:position=>3)
    assert one.enable(two)
    assert one.enable(three)
    assert one.allow?(two)
    assert one.allow?(three)
    assert one.disable(two)
    assert !one.allow?(two)    
  end
  
end
