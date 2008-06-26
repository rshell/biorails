require File.dirname(__FILE__) + '/../test_helper'
# Re-raise errors caught by the controller.
class SessionHelperTest < TestHelper
  include SessionHelper

  def setup
    Project.current = Project.find(2)
    User.current = User.find(3)
  end  
  

  def test_link_to_assert
    html = link_to_object(ProjectAsset.find(:first))
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_link_to_content
    html = link_to_object(ProjectContent.find(:first))
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_link_to_folder
    html = link_to_object(ProjectFolder.find(:first))
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_link_to_element
    html = link_to_object(ProjectElement.find(:first))
    assert html.is_a?(String)
    assert html.size>0
  end

  def test_link_to_processz
    html = link_to_object(ProtocolVersion.find(:first))
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_link_to_model_assert
    html = link_to_model(ProjectAsset,1)
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_link_model_to_content
    html = link_to_model(ProjectContent,2)
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_link_to_model_folder
    html = link_to_model(ProjectFolder,2)
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_link_to_model_element
    html = link_to_model(ProjectElement,1)
    assert html.is_a?(String)
    assert html.size>0
  end

end
