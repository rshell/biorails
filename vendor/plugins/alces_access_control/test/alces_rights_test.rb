require 'test/unit'

class AlcesRightsTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def test_this_plugin
    flunk
  end
  
  
  def test_has_permission
     owner = Project.find(:first)
           
     owner.permission?(user,subject,action)

  end
  
  def test_visiable
    object = Project.find(:first)
    assert object.visible?        
  end

  def test_changable
    object = Project.find(:first)
    assert object.allowed_to?(:update)        
    assert object.allowed_to?(:create)        
    assert object.allowed_to?(:delete)        
    assert object.allowed_to?(:publish)        
    assert object.allowed_to?(:withdraw)        
  end

  def test_changable
    object = Project.find(:first)
    assert object.status = :publish      
    assert !object.allowed_to?(:create)        
    assert !object.allowed_to?(:delete)        
    assert !object.allowed_to?(:publish)        
    assert object.allowed_to?(:withdraw)        
  end
  
  
end
