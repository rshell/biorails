require File.dirname(__FILE__) + '/../test_helper'

class DataSystemsTest < Test::Unit::TestCase
  fixtures :data_contexts
  fixtures :data_systems

#  NEW_DATA_SYSTEM = { :name =>"Demo", 
#                      :description => 'A description',
#                      :adapter => 'mysql',
#                      :host => 'localhost',
#                      :username => 'root',
#                      :password => nil, 
#                      :database => nil,
#                      :test_object => 'My beautiful test object'}

  # Replace this with your real tests.
  def test_new
    assert truth
#    data_system = DataSystem.new(NEW_DATA_SYSTEM)
#    assert_kind_of DataSystem, data_system
#    assert data_system.valid?, "DataSystem should be valid"
#    NEW_DATA_SYSTEM.each do |attr_name|
#      assert_equal NEW_DATA_SYSTEM[attr_name], data_system.attributes[attr_name], "DataSystem.@#{attr_name.to_s} incorrect"
#    end
#    assert data_system.save
  end
  

#  updated_at: 2006-10-12 14:19:40
#  access_control_id: 
#  created_by: sys
#  username: biorails
#  adapter: mysql
#  lock_version: "2"
#  data_context_id: "1"
#  test_object: tmp_data
#  updated_by: sys
#  id: "1"
#  description: Demo systems for some inventory
#  host: localhost
#  database: beagle_development
#  password: moose
#  created_at: 2006-10-09 12:11:25


end
