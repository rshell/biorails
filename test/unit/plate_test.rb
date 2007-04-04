require File.dirname(__FILE__) + '/../test_helper'

class PlateTest < Test::Unit::TestCase
  fixtures :plates

  def assert_ok(object)
     assert_not_nil object, ' Object is missing'
     assert object.errors.empty? , " #{object.class}.#{object.id} has errors: "+object.errors.full_messages().join(',')
     assert object.valid?,         " #{object.class}.#{object.id} not valid: "+object.errors.full_messages().join(',')
     assert !object.new_record?,   " #{object.class}:#{object} not saved"
  end
  
  def test_retrieve
    plate = Plate.find(:first) 
    assert_ok plate
  end

end

