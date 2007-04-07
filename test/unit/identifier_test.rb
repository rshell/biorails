require File.dirname(__FILE__) + '/../test_helper'

class IdentifierTest < Test::Unit::TestCase
  fixtures :identifiers
  fixtures :users

  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_generate
     user = User.find(:first)
     name = Identifier.next_id(Study)
     assert_not_nil name
     name2 = Identifier.next_id(Study)
     assert !(name==name2)
  end
end
