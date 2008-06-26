require File.dirname(__FILE__) + '/../test_helper'

class CrossTabFilterTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def assert_ok(object)
    assert_not_nil object, ' Object is missing'
    assert object.cross_tab_id, "no master cross tab"
    assert object.cross_tab_column_id, "missing column" 
    assert object.errors.empty? , " #{object.class}.#{object.id} has errors: "+object.errors.full_messages().join(',')
    assert object.valid?,         " #{object.class}.#{object.id} not valid: "+object.errors.full_messages().join(',')
    assert !object.new_record?,   " #{object.class}:#{object} not saved"
  end
  
  def create_cross_tab(name)
    sar = CrossTab.new({:name=>name,:description=>'sssss'})     
    assert sar.save , sar.errors.full_messages().join('\n')
    sar.add_columns(ProcessInstance.find(2))
    sar.add_columns(ProcessInstance.find(4))
    return sar
  end
  
  def test001_new_invalid
    column = CrossTabFilter.new
    assert !column.valid? ,"Should mandate a column" 
  end
  
  def test002_save
    sar = create_cross_tab('test14')
    column = sar.filters.add(sar.columns[0],'=','1')
    assert sar.save , sar.errors.full_messages().join('\n')
    assert_ok column
  end 

  def test_rule_equal
    sar = create_cross_tab('filter-test2')
    for column in sar.columns
      filter = sar.filters.add(column,'=','1')
      assert_ok filter
      assert filter.exists_rule 
    end
  end 

  def test_rule_gt
    sar = create_cross_tab('filter-test3')
    for column in sar.columns
      filter = sar.filters.add(column,'>','1')
      assert_ok filter
      assert filter.exists_rule 
    end
  end 
  
  def test_rule_lt
    sar = create_cross_tab('filter-test4')
    for column in sar.columns
      filter = sar.filters.add(column,'<','1')
      assert_ok filter
      assert filter.exists_rule 
    end
  end 
  
  def test_rule_like
    sar = create_cross_tab('filter-test5')
    for column in sar.columns
      filter = sar.filters.add(column,'like','1')
      assert_ok filter
      assert filter.exists_rule 
    end
  end 
  
  def test_rule_starting
    sar = create_cross_tab('filter-test6')
    for column in sar.columns
      filter = sar.filters.add(column,'starting','1')
      assert_ok filter
      assert filter.exists_rule 
    end
  end 
  
  def test_rule_ending
    sar = create_cross_tab('filter-test7')
    for column in sar.columns
      filter = sar.filters.add(column,'ending','1')
      assert_ok filter
      assert filter.exists_rule 
    end
  end 
  
  def test_rule_contains
    sar = create_cross_tab('filter-test8')
    for column in sar.columns
      filter = sar.filters.add(column,'contains','1,2,3')
      assert_ok filter
      assert filter.exists_rule 
    end
  end 

  
  def test_rule_invalid_operation
    sar = create_cross_tab('filter-test9')
    for column in sar.columns
      filter = sar.filters.add(column,'xxxx','1,2,3')
      assert_ok filter
      assert filter.exists_rule 
    end
  end 
  
end
