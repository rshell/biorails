require File.dirname(__FILE__) + '/../test_helper'

class StudyQueueTest < Test::Unit::TestCase
  fixtures :study_queues

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_item_add
     sq = StudyQueue.find(10)
     li = ListItem.find(1)
     sq.items.add(li)
  end
  
  def text_item_add_with_request
     rq = RequestService.find(16)
     sq = rq.service
     li = rq.request.items[0]
     sq.items.add(li,rq)     
  end
  
end
