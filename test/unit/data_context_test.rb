require File.dirname(__FILE__) + '/../test_helper'

class DataContextsTest < Test::Unit::TestCase
  fixtures :data_contexts
 
  # Replace this with your real tests.
  def test_truth
    assert true
  end
    
  #def test_crud
  #    context = DataContext.new( name=>'test',description =>'test')
  #    context.save     
  #    c2 = DataContext.find_by_name("test")  
  #    assert c1!=nil          
  #end
end
