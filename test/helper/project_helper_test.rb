require File.dirname(__FILE__) + '/../test_helper'
require 'application'


# Re-raise errors caught by the controller.
class ProjectHelperTest < TestHelper
  include Project::ProjectsHelper
  
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
  
  def test_project_render_string
    html = project_render('show')
    assert html.is_a?(String)
    assert html.size>0
    assert_equal 'mock', html    
  end

  def test_project_render_action
    html = project_render(:action=>'show')
    assert html.is_a?(String)
    assert html.size>0
    assert_equal 'mock', html    
  end

  def test_project_render_action_with_layout
    html = project_render(:action=>'show',:layout=>'simple')
    assert html.is_a?(String)
    assert html.size>0
    assert_equal 'mock', html    
  end

  def test_project_render_partial
    html = project_render(:partial=>'show')
    assert html.is_a?(String)
    assert html.size>0
  end

  def test_project_render_partial
    html = project_render(:partial=>'show',:collection=>'xxxx')
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_project_render_inline
    html = project_render(:inline=>'show')
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_project_render_file
    html = project_render(:file=>'show')
    assert html.is_a?(String)
    assert html.size>0
  end

end