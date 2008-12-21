require File.dirname(__FILE__) + '/../test_helper'
require 'application'


# Re-raise errors caught by the controller.
class ProjectHelperTest < TestHelper
  include ProjectsHelper
  
  def setup
    Project.current = Project.find(2)
    User.current = User.find(3)
  end  
  
  def render_template(*arg)
    "mock"
  end

  def render_file(*arg)
    "mock"
  end
  
  def render_partial(*arg)
    "mock"
  end
  
  def render_partial_collection(*args)
    "mock"
  end
  
  def partial_pieces(*args)
    "mock"
  end

end