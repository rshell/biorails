require File.dirname(__FILE__) + '/../test_helper'

require 'json'
require 'hpricot'
# Re-raise errors caught by the controller.
class ProjectFolderHelperTest < TestHelper
  include FoldersHelper
  
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
  
  
end