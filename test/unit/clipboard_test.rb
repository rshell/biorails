require File.dirname(__FILE__) + '/../test_helper'

# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

class ClipboardTest  < Test::Unit::TestCase

  def test_new
    clip = Clipboard.new
    assert clip
    assert_equal 0,clip.size
    assert_equal [],clip.marshal_dump
  end

   def test_dump_load
    clip = Clipboard.new
    items = Project.find(2).folder.elements.collect{|i|i.id}
    clip.marshal_load(items)
    assert_equal items.size,clip.size
    assert_equal items,clip.marshal_dump
    clip.clear
    assert_equal [],clip.marshal_dump    
  end
 
  def test_add_elements
    element = ProjectContent.find(:first)
    clip = Clipboard.new
    clip.add(element)
    assert_equal 1,clip.size
    assert_equal [element.id],clip.marshal_dump    
    assert_equal [nil],clip.filter(DataElement)
  end
  
end
