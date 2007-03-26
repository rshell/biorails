require File.dirname(__FILE__) + '/../test_helper'

class PlateTest < Test::Unit::TestCase
  fixtures :plates

  def test_retrieve
    plate = Plate.find(:first) 
    assert_equal 1, plate.id, "Incorrect Id"
    assert_equal 'PlateFirst', plate.name, "Incorrect Name"
    assert_equal 'A plate', plate.description, "Incorrect description"
    assert_equal 'their plate', plate.external_ref, "Incorrect external ref"
    assert_equal 'µm', plate.quantity_unit, "Incorrect unit"
    assert_equal 20.00, plate.quantity_value, "Incorrect plate quantity"
    assert_equal 'http://biorails.org', plate.url, "Incorrect URL"
  end

end

