require File.dirname(__FILE__) + '/../test_helper'

class AssayWorkflowTest < Test::Unit::TestCase

	NEW_STUDY_PROTOCOL = {:name => 'test'}	# e.g. {:name => 'Test AssayWorkflow', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w(name ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve ## Biorails::Dba.import_model via their name
    # @first = assay_protocols(:first)
    User.current = User.find(3)
    Project.current = Project.find(2)    
  end

def test01_versions
    protocol = AssayWorkflow.find(:first)
    list = protocol.versions
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test02_versions_using_role
    protocol = AssayWorkflow.find(:first)
    scope = ParameterRole.find(:first)
    list = protocol.versions.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test03_versions_using_assay_parameter
    protocol = AssayWorkflow.find(:first)
    scope = AssayParameter.find(:first)
    list = protocol.versions.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test04_versions_using_data_format
    protocol = AssayWorkflow.find(:first)
    scope = DataFormat.find(:first)
    list = protocol.versions.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test05_versions_using_data_element
    protocol = AssayWorkflow.find(:first)
    scope = DataElement.find(:first)
    list = protocol.versions.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test06_versions_using_data_type
    protocol = AssayWorkflow.find(:first)
    scope = DataType.find(:first)
    list = protocol.versions.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test07_versions_using_parameter_context
    protocol = AssayWorkflow.find(:first)
    scope = ParameterContext.find(:first)
    list = protocol.versions.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end
  
  def test08_versions_using_type
    protocol = AssayWorkflow.find(:first)
    scope = ParameterType.find(:first)
    list = protocol.versions.using(scope)
    assert list
    assert list.is_a?(Array), "#{list.class} should have been a Array"
  end

  def test09_find
     first = AssayWorkflow.find(:first)
     assert first.id
     assert first.name
     assert first.project
     assert first.team
  end
  
  def test10_new_invalid
    first = AssayWorkflow.new
    assert first
    assert first.new_record?
    assert !first.valid?
  end

  def test11_new_valid
    protocol = AssayWorkflow.new(:name=>"test14",:description=>'test14')
    protocol.assay = Assay.find(:first)
    assert protocol.save
    assert protocol.valid?
  end

  def test15_update
    first = AssayWorkflow.find(:first)
    assert first.save
    assert !first.new_record?
    assert first.valid?
  end
  
  def test16_has_name
    first = AssayWorkflow.find(:first)
    assert first.name    
  end

  def test17_has_description
    first =AssayWorkflow.find(:first)
    assert first.description    
  end

  def test18_test_to_xml
    type = AssayWorkflow.find(:first)
    assert type.to_xml    
  end
  
  def test19_test_used?
    type = ParameterType.find(:first)
    assert type.used? ==!type.not_used    
  end
  
  def test20_test_style
    type = ParameterType.find(:first)
    assert type.style
  end

  def test21_test_path
    type = ParameterType.find(:first)
    assert_equal type.path, type.name
  end
  
  def test22_data_type
    type = ParameterType.find(:first)
    assert type.data_type    
  end
  
  def test23_from_xml
    type = ParameterType.find(:first)
    xml = type.to_xml
    assert xml
    type2 = ParameterType.from_xml(xml)
    assert type2
    assert type2.is_a?(ParameterType)
    assert_equal type2.name,type.name
  end
  
  def test24_defintion
     first = AssayWorkflow.find(:first)
     assert_equal first.definition, first
  end
  
  def test25_purge
     first = AssayWorkflow.find(:first)
     assert first.purge
  end
  
  def test26_visible_first
     assert AssayWorkflow.visible(:first)
  end

  def test26_visible_all
     assert AssayWorkflow.visible(:all)
  end
  
  def test27_editable
     first = AssayWorkflow.find(:first)
     top =  first.editable
     assert top
  end
    
  def test29_latest
     first = AssayWorkflow.find(:first)
     assert first.latest
  end
  
  def test30_usage_count
     first = AssayWorkflow.find(:first)
     assert first.usage_count
  end
  
  def test_is_multistep
    first = AssayWorkflow.find(:first)
    assert first.multistep?
  end
  
  def test_version
    first = AssayWorkflow.find(:first)
    assert first.version(1)
  end  
  
  def test_usages_count
    first = AssayWorkflow.find(:first)
    assert first.usage_count
  end  

  def test_released_exception
    first = AssayWorkflow.new
    assert_equal nil, first.released
  end   
  def test_raw_validation
    assay_protocol = AssayWorkflow.new
    assay_protocol.name=nil
    assay_protocol.description=nil
    if REQ_ATTR_NAMES.blank?
      assert assay_protocol.valid?, "AssayWorkflow should be valid without initialisation parameters"
    else
      # If AssayWorkflow has validation, then use the following:
      assert !assay_protocol.valid?, "AssayWorkflow should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert assay_protocol.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

  def test_duplicate
    current_assay_protocol = AssayWorkflow.find(:first)
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
            assay_protocol = AssayWorkflow.new(NEW_STUDY_PROTOCOL.merge(attr_name.to_sym => current_assay_protocol[attr_name]))
            assert !assay_protocol.valid?, "AssayWorkflow should be invalid, as @#{attr_name} is a duplicate"
            assert assay_protocol.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
  end
end

