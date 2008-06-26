require File.dirname(__FILE__) + '/../test_helper'
# Re-raise errors caught by the controller.
class CatalogueHelperTest < TestHelper
  include Admin::CatalogueHelper
  
  def setup
    Project.current = Project.find(2)
    User.current = User.find(3)
  end  
  
  def catalogue_url(*arg)
    return "mock"
  end
  
  def test_data_concepts_to_json
    @elements = DataContext.find(:first).children
    html = data_concepts_to_json(@elements)
    assert html.is_a?(String)
    assert html.size>0
  end
  
end
