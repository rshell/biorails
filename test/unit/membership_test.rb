require File.dirname(__FILE__) + '/../test_helper'

class MembershipTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :user_roles
  ## Biorails::Dba.import_model :project_roles
  ## Biorails::Dba.import_model :users
  ## Biorails::Dba.import_model :projects
  ## Biorails::Dba.import_model :memberships

  # Replace this with your real tests.
 def setup
     @model = Membership
  end
  
  def test_truth
    assert true
  end
  
  def test_find
     first = @model.find(:first)
     assert first.id
     assert first.role
     assert first.user
     assert first.project
  end
    
    def test_valid
    first = @model.find(:first)
    assert first.valid?   
  end

  def test_update
    first = @model.find(:first)
    assert first.save  
  end

  def test_to_s
    first = @model.find(:first)
    assert !first.to_s.nil?  
  end

  def test_to_json
    first = @model.find(:first)
    assert !first.to_json.nil?  
  end

  def test_to_xml
    first = @model.find(:first)
    assert !first.to_xml.nil?  
  end
  

end
