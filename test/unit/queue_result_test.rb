require File.dirname(__FILE__) + '/../test_helper'

class QueueResultTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :queue_results

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_find
    x = QueueResult.find(:all)
    assert x
  end
end
