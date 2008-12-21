require File.dirname(__FILE__) + '/../test_helper'
# Re-raise errors caught by the controller.
class SessionHelperTest < TestHelper
  include SessionHelper

  def setup
    Project.current = Project.find(2)
    User.current = User.find(3)
  end  

  def test_breadcrumb_list_no_status
    assert breadcrumb_list_no_status(ProjectFolder.find(:first))
  end

  def test_breadcrumb_list
    assert breadcrumb_list(ProjectFolder.find(:first))
  end
  
end
