require File.dirname(__FILE__) + '/../test_helper'
# Re-raise errors caught by the controller.
class SessionHelperTest < TestHelper
  include SessionHelper

  def setup
    Project.current = Project.find(2)
    User.current = User.find(3)
  end  
  
end
