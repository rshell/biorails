require File.dirname(__FILE__) + '/../test_helper'

class PermissionTest < Test::Unit::TestCase
  fixtures :permissions

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_rebuild
     assert_not_nil Permission.locate('studies','show')
  end
  
  def test_rebuild
     Permission.rebuild
     assert_not_nil Permission.locate('studies','show')
  end


end
