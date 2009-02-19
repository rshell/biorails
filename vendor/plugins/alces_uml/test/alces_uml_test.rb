require 'test/unit'

class AlcesUmlTest <Test::Unit::TestCase
  # Replace this with your real tests.
  def test_this_plugin
    flunk
  end
  
  def test_list_of_models
     models = Alces.UmlModel.models
     assert_to_nil models, "Check models returns"
  end
  
  
  def test_list_of_controllers
     models = Alces.UmlModel.controllers
     assert_to_nil models, "Check controllers returns"   
  end

  def test_list_of_controllers
     models = Alces.UmlModel.controllers
     assert_to_nil models, "Check controllers returns"   
  end

end
