require File.dirname(__FILE__) + '/../test_helper'

class AssayProcessTest < Test::Unit::TestCase

  def setup
    # Retrieve ## Biorails::Dba.import_model via their name
    # @first = assay_protocols(:first)
    User.current = User.find(3)
    Project.current = Project.find(2)    
  end

def test01_versions
    protocol = AssayProcess.find(:first)
    list = protocol.versions
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test02_versions_using_role
    protocol = AssayProcess.find(:first)
    scope = ParameterRole.find(:first)
    list = protocol.versions.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test03_versions_using_assay_parameter
    protocol = AssayProcess.find(:first)
    scope = AssayParameter.find(:first)
    list = protocol.versions.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test04_versions_using_data_format
    protocol = AssayProcess.find(:first)
    scope = DataFormat.find(:first)
    list = protocol.versions.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test05_versions_using_data_element
    protocol = AssayProcess.find(:first)
    scope = DataElement.find(:first)
    list = protocol.versions.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test06_versions_using_data_type
    protocol = AssayProcess.find(:first)
    scope = DataType.find(:first)
    list = protocol.versions.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test07_versions_using_parameter_context
    protocol = AssayProcess.find(:first)
    scope = ParameterContext.find(:first)
    list = protocol.versions.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test08_versions_using_type
    protocol = AssayProcess.find(:first)
    scope = ParameterType.find(:first)
    list = protocol.versions.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test09_find
     first = AssayProcess.find(:first)
     assert first.id
     assert first.name
     assert first.project
  end
  
  def test10_new_invalid
    first = AssayProcess.new
    assert first
    assert first.new_record?
    assert !first.valid?
  end

  def test11_new_valid
    protocol = AssayProcess.new(:name=>"test14",:description=>'test14')
    protocol.assay = Assay.find(:first)
    assert protocol.save
    assert protocol.valid?
    assert_equal nil,protocol.released
  end

  def test15_update
    first = AssayProcess.find(:first)
    assert first.save
    assert !first.new_record?
    assert first.valid?
  end
  
  def test16_has_name
    first = AssayProcess.find(:first)
    assert first.name    
  end

  def test17_has_description
    first =AssayProcess.find(:first)
    assert first.description    
  end

  def test18_test_to_xml
    type = AssayProcess.find(:first)
    assert type.to_xml    
  end
  
  def test24_defintion
     first = AssayProcess.find(:first)
     assert_equal first.definition, first
  end
  
  def test25_purge
     first = AssayProcess.find(:first)
     assert first.purge
  end
  
  def test26_visible_first
     assert AssayProcess.visible(:first)
  end

  def test26_visible_all
     assert AssayProcess.visible(:all)
  end
  
  def test27_editable
     first = AssayProcess.find(:first)
     top =  first.editable
     assert top
  end
  
  def test28_released
     first = AssayProcess.find(1)
     assert first.released
  end
  
  def test29_latest
     first = AssayProcess.find(1)
     assert first.latest
  end
  
  def test30_usage_count
     first = AssayProcess.find(1)
     assert first.usage_count
  end
  
  def test31_description_validation
    assay_protocol = AssayProcess.new
    assay_protocol.description = nil
    assert !assay_protocol.valid?, "AssayProcess should not be valid without initialisation parameters"
    assert assay_protocol.errors.invalid?(:description), "Should be an error message for description"
  end

  def test32_name_validation
    assay_protocol = AssayProcess.new
    assay_protocol.name = nil
    assert !assay_protocol.valid?, "AssayProcess should not be valid without initialisation parameters"
    assert assay_protocol.errors.invalid?(:name), "Should be an error message for description"
  end

  def test33_summary
     first = AssayProcess.find(1)
     assert first.summary
  end

  def test_not_multistep
    first = AssayProcess.find(:first)
    assert !first.multistep?
  end
  
  def test_version
    first = AssayProcess.find(:first)
    assert first.version(1)
  end  
  
  def test_usages_count
    first = AssayProcess.find(:first)
    assert first.usage_count
  end  

  def test_released_exception
    first = AssayProcess.new
    assert_equal nil, first.released
  end   
end

