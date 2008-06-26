require File.dirname(__FILE__) + '/../test_helper'

class CrossTabColumnTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def assert_ok(object)
     assert_not_nil object, ' Object is missing'
     assert object.cross_tab_id, "no master cross tab"
     assert object.assay_parameter_id, "missing assay parameter" 
     assert object.parameter_type_id, "missing parameter type"
     assert object.errors.empty? , " #{object.class}.#{object.id} has errors: "+object.errors.full_messages().join(',')
     assert object.valid?,         " #{object.class}.#{object.id} not valid: "+object.errors.full_messages().join(',')
     assert !object.new_record?,   " #{object.class}:#{object} not saved"
  end
  
  def create_cross_tab(name)
     sar = CrossTab.new({:name=>'test3',:description=>'sssss'})     
     assert sar.save , sar.errors.full_messages().join('\n')
     return sar
  end
  
  def test001_new_invalid
     column = CrossTabColumn.new
     assert !column.valid? , "Should mandate a name"
     column = CrossTabColumn.new(:name=>'test1')
     assert column.path, "has a label"
     assert !column.valid? ,"Should mandate a parameter" 
  end

  def test002_new_valid_via_parameter
     sar = create_cross_tab('test2')
     column = CrossTabColumn.new(:name=>'col1')
     column.cross_tab = sar
     column.parameter = Parameter.find(:first)
     assert column.parameter_type
     assert column.assay_parameter_id
     assert column.parameter_role
     assert column.path, "has a label"
     assert column.valid? , column.errors.full_messages().join('\n')
  end

  def test003_new_valid_via_assay_parameter
     sar = create_cross_tab('test3')
     column = CrossTabColumn.new(:name=>'col1')
     column.cross_tab = sar
     column.assay_parameter = AssayParameter.find(:first)
     assert column.path, "has a label"
     assert column.valid? , column.errors.full_messages().join('\n')
  end
  
  def test004_save
     sar = create_cross_tab('test4')
     column = CrossTabColumn.new(:name=>'col1')
     column.cross_tab = sar
     column.parameter = Parameter.find(:first)
     assert column.save , column.errors.full_messages().join('\n')
     assert_ok column
  end 

end
