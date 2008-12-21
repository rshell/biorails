require File.dirname(__FILE__) + '/../test_helper'
# Re-raise errors caught by the controller.
class FoldersHelperTest < TestHelper
  include FoldersHelper
  
  def setup
    Project.current = Project.find(2)
    User.current = User.find(3)
  end
  def right?(*arg)
    return true
  end

  def test_folder_to_json_root
    folder = ProjectFolder.find(:first)
    data = folder_to_json( folder,elements = nil)
    assert data
    assert data.is_a?(String)
  end

  def test_folder_to_json_child
    folder = ProjectFolder.find(:first,:conditions=>"project_id is not null")
    data = folder_to_json( folder,elements = nil)
    assert data
    assert data.is_a?(String)
  end

  def test_folder_to_json_asset
    folder = ProjectAsset.find(:first,:conditions=>"project_id is not null").parent
    data = folder_to_json( folder,elements = nil)
    assert data
    assert data.is_a?(String)
  end

  def test_folder_to_json_content
    folder = ProjectContent.find(:first,:conditions=>"project_id is not null").parent
    data = folder_to_json( folder,elements = nil)
    assert data
    assert data.is_a?(String)
  end

end
