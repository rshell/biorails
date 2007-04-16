require 'test/unit'

class AlcesRightsTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def test_this_plugin
    flunk
  end
  
  
  def test_has_permission
     owner = Project.find(:first)
           
     owner.permission?(user,subject,action)

  end
end
