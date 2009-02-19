require 'test/unit'

class AlcesScheduledTest <Test::Unit::TestCase
  # Replace this with your real tests.
  def test_this_plugin
    flunk
  end
  
  def test
     stuff =User.find(1)
     stuff.tasks.overdue.size
     stuff.tasks.current.size
     stuff.tasks.future.size
     
  end
end
