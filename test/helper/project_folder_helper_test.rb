require File.dirname(__FILE__) + '/../test_helper'

require 'json'
require 'hpricot'
# Re-raise errors caught by the controller.
class ProjectFolderHelperTest < TestHelper
  include Project::FoldersHelper
  
  def setup
    Project.current = Project.find(2)
    ProjectFolder.current = Project.current.home
    User.current = User.find(3)
  end  
  
  def test_folder_to_json
    html = folder_to_json(ProjectFolder.current)
    assert html.is_a?(String)
    assert html.size>0
    folder=ProjectFolder.find(1)
    parsed_json= JSON.parse(folder_to_json(folder))
    assert_not_nil parsed_json['items']   
    assert_not_nil parsed_json['path']   
    assert_not_nil parsed_json['folder_id']   
    assert_not_nil parsed_json['total']   
   end
  
  def test_element_to_json_or_url
    html = element_to_json_or_url(ProjectElement.find(1))
    assert html.is_a?(String)
    assert html.size>0
    folder=ProjectFolder.find(:first)
    assert_equal '<a href="mock">home</a>', element_to_json_or_url(folder)
  end

  def test_element_to_json_or_url2
    html = element_to_json_or_url(ProjectContent.find(60))
    assert html.is_a?(String)
    assert html.size>0
    content=ProjectContent.find(:first)
    parsed_json= JSON.parse(element_to_json_or_url(content))
    assert_equal 'test1', parsed_json['title']
  end

  def test_element_to_json_or_url3
    html = element_to_json_or_url(ProjectAsset.find(30))
    assert html.is_a?(String)
    assert html.size>0
    asset=ProjectAsset.find(:first)
    parsed_json= JSON.parse(element_to_json_or_url(asset))
    assert_equal 'microexambm42.jpg',parsed_json['title']
  end
  
end