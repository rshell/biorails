require File.dirname(__FILE__) + '/../test_helper'

class ParameterTypeAliasTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
    def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = ParameterTypeAlias
  end
  
  def test00_new
    item = ParameterTypeAlias.new
    assert item
    assert_equal "none", item.element_name
    assert_equal "none", item.format_name
    assert_equal "undefined", item.role_name
    assert_equal "undefined", item.style
    assert_equal nil, item.type
  end


  def test01_find_one
    item = ParameterTypeAlias.find(:first)
    assert item
    assert item.name
    assert item.element_name
    assert item.description
  end

  
  def test02_type_has_alias_list
    item = ParameterType.find(:first)
    assert item
    list = item.aliases
    assert list
    assert list.is_a?(Array), "Should have a array of aliases associated with a parameter type"
  end

  def test03_type_add_a_alias
    item = ParameterType.find(:first)
    assert item
    new_alias = item.add_alias('test03')
    assert new_alias, "should have build a alias"
    assert new_alias.valid?, "should be valid"
    assert_equal new_alias.name,"test03","Name is wrong"
    assert_equal new_alias.description,item.description,"descriptions should match it none is given"
    assert new_alias.save
  end

  def test04_not_allowed_duplicate_names
    item = ParameterType.find(:first)
    new_alias = item.add_alias('test03')
    assert new_alias.valid?
    failed_alias = item.add_alias('test03')
    assert !failed_alias.valid?  ,"duplicate named alias should not be valid"  
  end

  def test05_set_units
    item = ParameterType.find(:first,:conditions=>'data_type_id=2')
    new_alias = item.add_alias('test03')
    unit = item.units[0]
    new_alias.display_unit = unit
    assert new_alias.save ,"Should be able to save with a unit"
    assert new_alias.valid?
    new_alias.reload
    assert_equal new_alias.display_unit, unit, "Unit should match the set value"
  end

  def test06_set_role
    item = ParameterType.find(:first,:conditions=>'data_type_id=2')
    new_alias = item.add_alias('test03')
    role = ParameterRole.find(:first)
    new_alias.parameter_role = role
    assert new_alias.save , "should be able to save alias with a role"
    assert new_alias.valid?
    new_alias.reload
    assert_equal new_alias.parameter_role, role, "role should match the set value"
  end
  
  def test07_is_used
    item = ParameterType.find(:first,:conditions=>'data_type_id=2')
    new_alias = item.add_alias('test03')
    assert_nil new_alias.used?, " new alias should not be used?"
  end

  def test08_usages
    item = ParameterType.find(:first,:conditions=>'data_type_id=2')
    new_alias = item.add_alias('test03')
    assert_equal new_alias.usages,[] ,"new alias should no have usages"   
  end
  
  def test09_units
    item = ParameterType.find(:first,:conditions=>'data_type_id=2')
    new_alias = item.add_alias('test03')
    units = new_alias.units
    assert units, "failed to return a list of units"
    assert units.is_a?(Array)
    assert_equal units,item.units, "Units list matches parameter type"
  end

  def test10_update_description
    item = ParameterTypeAlias.find(:first)
    assert item
    item.description= "test010"
    assert item.save 
  end

  def test11_data_type_matches
    item = ParameterTypeAlias.find(:first)
    assert item
    assert_equal item.data_type , item.parameter_type.data_type
  end

   def test12_style_matches
    item = ParameterTypeAlias.find(:first)
    assert item
    assert_equal item.style , item.parameter_type.style
  end
 
  
end
