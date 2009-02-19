require File.dirname(__FILE__) + '/../test_helper'
require 'application_controller'

# Re-raise errors caught by the controller.
class ProjectTypesHelperTest < TestHelper
  include Admin::ProjectTypesHelper
  
  def setup
    Project.current = Project.find(2)
    User.current = User.find(3)
  end  
  
  def test_select_dashboard
    @project_type = ProjectType.new
    html = select_dashboard(:prject_type,:dashboard)
    assert html.is_a?(String)
    assert html.size>0
  end
  
end