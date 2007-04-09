require File.dirname(__FILE__) + '/../test_helper'

class DataElementsTest < Test::Unit::TestCase
  fixtures :data_concepts
  fixtures :projects
  fixtures :project_elements

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test001_node       
       node = TreeHelper::Node.new('xxx')
       assert_not_nil node
       assert_not_nil node
       assert node.name == 'xxx'
       assert_not_nil node.id 
  end     
  
  def test002_tree       
       node = TreeHelper::Tree.new('xxx')
       assert_not_nil node
       assert_not_nil node
       assert node.name == 'xxx'
       assert_not_nil node.id
  end     
  
  def test003_node   
       rec = DataConcept.find(:first)    
       root = TreeHelper::Tree.new('xxx')
       assert_not_nil root
       
       node = root.add_node(rec)
       puts node.children.collect{|i|i.name}.join(",")
       assert_not_nil node
       assert node.children.size>1
       assert node.name == rec.name
  end     
    
  def test004_to_jscript
       node = TreeHelper::Node.new('xxx')
       assert_not_nil node
       puts node.to_jscript("xx")
       assert node.to_jscript("xx")
  end 


   
end
