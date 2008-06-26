require File.dirname(__FILE__) + '/../test_helper'
# Re-raise errors caught by the controller.
class DataElementsHelperTest  < TestHelper
  include Admin::DataElementsHelper
  
  def setup
    Project.current = Project.find(2)
    User.current = User.find(3)
  end  
  
  def test_values
    @data_element = DataElement.find(:first)
    html = values
    assert html.is_a?(String)
    assert html.size>0
  end

  def test_values_exception
    @data_element = nil
    html = values
    assert html.is_a?(String)
  end

  def test_table_row
    html =table_row(nil)
    assert html.is_a?(String)
  end

  
  def test_table_from_array
    @items = []
    for i in 1..400
      @items << {'name'=>i.to_s,'id'=>i}
    end
    html = table_from_array(@items)
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_table_from_array_error1
    html = table_from_array(nil)
    assert html.is_a?(String)
  end

  def test_table_from_array_error2
    @items = []
    for i in 1..4
      @items << {'naddme'=>i.to_s,'issd'=>i}
    end
    html = table_from_array(@items)
    assert html.is_a?(String)
    assert html.size>0
  end
  
end
