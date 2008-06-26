require File.dirname(__FILE__) + '/../test_helper'

class CrossTabJoinTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_to_s
    x = CrossTabJoin.new
    assert_equal "",x.to_s
  end  

  def test_custom_to_s
    x = CrossTabJoin.new
    x.join_rule = :custom
    assert_equal "custom",x.to_s
  end  
  
end
