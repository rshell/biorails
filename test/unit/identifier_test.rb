require File.dirname(__FILE__) + '/../test_helper'

class IdentifierTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :identifiers
  ## Biorails::Dba.import_model :users

  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_generate
     user = User.find(:first)
     name = Identifier.next_id(Assay)
     assert_not_nil name
     name2 = Identifier.next_id(Assay)
     assert_not_equal name,name2
  end
  
  def test_find
    id = Identifier.find(:first)
    assert id
    assert_ok id
    assert id.project
    assert id.team
    assert id.user    
  end
  
  def test_need_to_define_exception_handling
   assert !Identifier.need_to_define(nil,nil)    
  end

  def test_create
    new_generater = Identifier.next_id(Compound)
    assert new_generater
    assert_ok Identifier.find_by_name('Compound')
  end
  
end
