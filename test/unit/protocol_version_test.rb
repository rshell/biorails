
require File.dirname(__FILE__) + '/../test_helper'

class ProtocolVersionTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def setup
     @model = ProtocolVersion
  end
  
  def test_find
     first = @model.find(:first)
     assert first.id
     assert first.name
     assert first.usages
     assert first.allowed_roles
     assert_equal !first.released?, first.withdrawn
     assert_equal first.released?, first.released
  end
  
  def test_find
     first = @model.find(:first)
     assert !first.can_destroy_if_not_used_or_release
  end

  def test_new
    first = @model.new
    assert first
    assert first.new_record?
    assert !first.valid?
  end

  def test_update
    first = @model.find(:first)
    assert first.save
    assert !first.new_record?
    assert first.valid?
  end
  
  def test_has_path
    first = @model.find(:first)
    assert first.path    
  end
  
  def test_has_name
    first = @model.find(:first)
    assert first.name    
  end

  def test_has_protocol
    first = @model.find(:first)
    assert !first.protocol.nil?   
  end  

  def test_to_xml
    first = @model.find(:first)
    assert first.to_xml
  end

end
