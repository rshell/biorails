require File.dirname(__FILE__) + '/../test_helper'

class CrossTabTest < ActiveSupport::TestCase
  
  def setup
    Project.current = @project = Project.find(2)    
    User.current = @user = User.find(3)  
    @cross_tab = CrossTab.find(:first)
    @sar = CrossTab.create(:name=>'live',:description=>'sssss',:project_id=>2)
    @sar.use_live = true
  end
   
  def test001_new_valid
     sar = CrossTab.new({:name=>'test001',:description=>'sssss'})
     assert sar.valid? , sar.errors.full_messages().join('\n')
  end

  def test002_new_invalid
     sar = CrossTab.new
     assert !sar.valid? , "Should mandate a name and description"
     sar = CrossTab.new(:name=>'test002')
     assert !sar.valid? ,"Should mandate a description" 
  end
  
  def test003_save
     sar = CrossTab.new(:name=>'test003',:description=>'sssss')
     assert sar.save , sar.errors.full_messages().join('\n')
     assert_ok sar
     assert sar.project, "Project added automatically"    
     assert sar.project_element , "Project Element added automatically"
     assert sar.columns.size==0, 'should have no columns yet'
     assert sar.filters.size==0, 'should have no filters yet '
  end 

  def test004_duplicate_name
     sar = CrossTab.new(:name=>'test4',:description=>'sssss')
     assert sar.save , sar.errors.full_messages().join('\n')
     sar = CrossTab.new(:name=>'test4',:description=>'sssss')
     assert !sar.valid? , "Should not allow duplicate name"
  end
   
  def test005_linked_item_parameters
    
    list = @sar.linked_items(:parameters)
    assert list
    assert list.is_a?(Array), "was {list.class} not a Array"
    if list.size>0
       assert list[0].is_a?(AssayParameter)
    end
  end
  
  def test006_linked_item_processs
    list = @sar.linked_items(:processes)
    assert list
    assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
    if list.size>0
       assert list[0].is_a?(ProtocolVersion) 
    end
  end

   def test007_linked_item_assays
    list = @sar.linked_items(:assays)
    assert list
    assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
    if list.size>0
    assert list[0].is_a?(Assay)
    end
  end

  def test008_linked_item_protocols
    list = @sar.linked_items(:protocols)
    assert list
    assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
    if list.size>0
    assert list[0].is_a?(AssayProtocol) 
    end
  end

  def test009_linked_item_parameter_types
    list = @sar.linked_items(:types)
    assert list
    assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
    if list.size>0
    assert list[0].is_a?(ParameterType) 
    end
  end

  def test010_linked_item_parameter_roles
    list = @sar.linked_items(:roles)
    assert list
    assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
    if list.size>0
       assert list[0].is_a?(ParameterRole)
    end
  end

  def test011_linked_to_1st_assay
    roots =  @sar.linked_items(:assays)
    roots.each do |item|
      list = @sar.linked_items(item)
      assert list
      assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
      if list.size>0
         assert list[0].is_a?(AssayProtocol)
      end
    end
  end

  def test012_linked_to_1st_protocol
    roots =  @sar.linked_items(:protocols)
    roots.each do |item|
      list = @sar.linked_items(item)
      assert list
      assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
      if list.size>0
        assert list[0].is_a?(ProtocolVersion)
      end
    end
  end

   def test013_linked_to_1st_processs
    roots =  @sar.linked_items(:processes)
    roots.each do |item|
      list = @sar.linked_items(item)
      assert list
      assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
      if list.size>0
        assert list[0].is_a?(ParameterContext)
      end
    end
  end

  def test014_linked_to_1st_parameter_role
    roots =  @sar.linked_items(:roles)
    roots.each do |item|
      list = @sar.linked_items(item)
      assert list
      assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
      if list.size>0
         assert list[0].is_a?(ParameterType)
      end
    end
    end

  def test015_linked_to_1st_parameter_type
    roots =  @sar.linked_items(:types)
    roots.each do |item|
      list = @sar.linked_items(item)
      assert list
      assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
      if list.size>0
         assert list[0].is_a?(ProtocolVersion)
      end
    end
  end
  
  def test016_add_column_as_parameter
    sar = CrossTab.new({:name=>'test016',:description=>'sssss'})
    assert sar.save , sar.errors.full_messages().join('\n')
    assert sar.add_columns(Parameter.find(:first))

  end

  def test017_add_column_as_context
    sar = CrossTab.new({:name=>'test016',:description=>'sssss'})
    assert sar.save , sar.errors.full_messages().join('\n')
    assert sar.add_columns(ParameterContext.find(:first))
  end

  def test018_add_column_as_process
    sar = CrossTab.new({:name=>'test016',:description=>'sssss'})
    assert sar.save , sar.errors.full_messages().join('\n')
    assert sar.add_columns(ProcessInstance.find(:first))
  end  
  
  def test019_add_column_as_process_duplicate
    sar = CrossTab.new({:name=>'test016',:description=>'sssss'})
    assert sar.save , sar.errors.full_messages().join('\n')
    assert sar.add_columns(ProcessInstance.find(:first))
    assert !sar.add_columns(ProcessInstance.find(:first))
  end  
  
  def test019_add_column_as_parameter_duplicate
    sar = CrossTab.new({:name=>'test019',:description=>'sssss'})
    assert sar.save , sar.errors.full_messages().join('\n')
    assert sar.add_columns(Parameter.find(:first))
    assert !sar.add_columns(Parameter.find(:first))
  end  
  
  def test019_add_column_as_invalid_type
    sar = CrossTab.new({:name=>'test019',:description=>'sssss'})
    assert sar.save , sar.errors.full_messages().join('\n')
    assert !sar.add_columns(DataElement.find(:first))
  end  
  
  def test020_convert_node_project
    item = Project.find(:first)
    item2 = CrossTab.convert_node(item.dom_id)
    assert item2
    assert_equal item,item2
  end
  
   def test021_convert_node_assay
    item = Assay.find(:first)
    item2 = CrossTab.convert_node(item.dom_id)
    assert item2
    assert_equal item,item2
  end
  
   def test022_convert_node_protocol
    item = AssayProtocol.find(:first)
    item2 = CrossTab.convert_node(item.dom_id)
    assert item2
    assert_equal item,item2
  end
  
   def test023_convert_node_text
    item = 'text'
    item2 = CrossTab.convert_node('text')
    assert item2
    assert_equal item,item2
  end
  
   def test024_convert_node_assay_parameter
    item = AssayParameter.find(:first)
    item2 = CrossTab.convert_node(item.dom_id)
    assert item2
    assert_equal item,item2
  end
  
   def test025_convert_node_version
    item = ProtocolVersion.find(:first)
    item2 = CrossTab.convert_node(item.dom_id)
    assert item2
    assert_equal item,item2
  end
  
   def test026_convert_node_process
    item = ProcessInstance.find(:first)
    item2 = CrossTab.convert_node(item.dom_id)
    assert item2
    assert_equal item,item2
  end
  
   def test027_convert_node_type
    item = ParameterType.find(:first)
    item2 = CrossTab.convert_node(item.dom_id)
    assert item2
    assert_equal item,item2
  end
  
   def test028_convert_node_role
    item = ParameterRole.find(:first)
    item2 = CrossTab.convert_node(item.dom_id)
    assert item2
    assert_equal item,item2
  end

   def test029_convert_node_context
    item = ParameterContext.find(:first)
    item2 = CrossTab.convert_node(item.dom_id)
    assert item2
    assert_equal item,item2
  end

   def test030_estimated_rows
    sar = CrossTab.new({:name=>'test030',:description=>'sssss'})
    assert sar.save , sar.errors.full_messages().join('\n')
    assert sar.add_columns(ProcessInstance.find(:first))
    assert sar.estimated_rows
  end
 
   def test031_estimated_tasks   
    sar = CrossTab.new({:name=>'test031',:description=>'sssss'})
    assert sar.save , sar.errors.full_messages().join('\n')
    assert sar.add_columns(ProcessInstance.find(:first))
    assert sar.estimated_tasks    
  end
 
  
   def test032_results
    sar = CrossTab.new({:name=>'test032',:description=>'sssss'})
    assert sar.save , sar.errors.full_messages().join('\n')
    assert sar.add_columns(ProcessInstance.find(:first))
    assert sar.results
  end

   def test033_task_contexts
    sar = CrossTab.new({:name=>'test033',:description=>'sssss'})
    assert sar.save , sar.errors.full_messages().join('\n')
    assert sar.add_columns(ProcessInstance.find(:first))
    assert sar.task_contexts
  end

   def test034_filters
    sar = CrossTab.new({:name=>'test034',:description=>'sssss'})
    assert sar.save , sar.errors.full_messages().join('\n')
    assert sar.filters.using(Parameter.find(:first))
    assert sar.filters.using(ParameterContext.find(:first))
    assert sar.filters.using(:global)
    assert sar.filters.using(nil)
  end
   
   def test035_joins
    sar = CrossTab.new({:name=>'test034',:description=>'sssss'})
    assert sar.save , sar.errors.full_messages().join('\n')
    assert sar.joins
    assert_nil sar.joins.link(Parameter.find(:first),Parameter.find(:first))
    assert sar.joins.as_reference(Parameter.find(:first),Parameter.find(:first))
    assert sar.joins.link(Parameter.find(:first),Parameter.find(:first))
    assert sar.joins.as_parent(Parameter.find(:first),Parameter.find(:first))
    assert sar.joins.as_child(Parameter.find(:first),Parameter.find(:first))
  end

  def test035_linked_item_parameters
    @sar.use_live = false
    list = @sar.linked_items(:parameters)
    assert list
    assert list.is_a?(Array), "was {list.class} not a Array"
    if list.size>0
       assert list[0].is_a?(AssayParameter)
    end
  end
  
  def test036_linked_item_processs
    @sar.use_live = false
    list = @sar.linked_items(:processes)
    assert list
    assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
    if list.size>0
       assert list[0].is_a?(ProtocolVersion) 
    end
  end

   def test037_linked_item_assays
    @sar.use_live = false
    list = @sar.linked_items(:assays)
    assert list
    assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
    if list.size>0
    assert list[0].is_a?(Assay)
    end
  end

  def test038_linked_item_protocols
    @sar.use_live = false
    list = @sar.linked_items(:protocols)
    assert list
    assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
    if list.size>0
    assert list[0].is_a?(AssayProtocol) 
    end
  end

  def test039_linked_item_parameter_types
    @sar.use_live = false
    list = @sar.linked_items(:types)
    assert list
    assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
    if list.size>0
    assert list[0].is_a?(ParameterType) 
    end
  end

  def test040_linked_item_parameter_roles
    @sar.use_live = false
    list = @sar.linked_items(:roles)
    assert list
    assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
    if list.size>0
       assert list[0].is_a?(ParameterRole)
    end
  end

  def test041_linked_to_1st_assay
    @sar.use_live = false
    roots =  @sar.linked_items(:assays)
    roots.each do |item|
      list = @sar.linked_items(item)
      assert list
      assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
      if list.size>0
         assert list[0].is_a?(AssayProtocol)
      end
    end
  end

  def test042_linked_to_1st_protocol
    @sar.use_live = false
    roots =  @sar.linked_items(:protocols)
    roots.each do |item|
      list = @sar.linked_items(item)
      assert list
      assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
      if list.size>0
        assert list[0].is_a?(ProtocolVersion)
      end
    end
  end

   def test043_linked_to_1st_processs
    @sar.use_live = false
    roots =  @sar.linked_items(:processes)
    roots.each do |item|
      list = @sar.linked_items(item)
      assert list
      assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
      if list.size>0
        assert list[0].is_a?(ParameterContext)
      end
    end
  end

  def test044_linked_to_1st_parameter_role
    @sar.use_live = false
    roots =  @sar.linked_items(:roles)
    roots.each do |item|
      list = @sar.linked_items(item)
      assert list
      assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
      if list.size>0
         assert list[0].is_a?(ParameterType)
      end
    end
    end

  def test045_linked_to_1st_parameter_type
    @sar.use_live = false
    roots =  @sar.linked_items(:types)
    roots.each do |item|
      list = @sar.linked_items(item)
      assert list
      assert list.is_a?(Array), "was {list.class} not a Array :#{list}"
      if list.size>0
         assert list[0].is_a?(ProtocolVersion)
      end
    end
  end

  def test046_linked_item_root_live
    @sar.use_live = true
    list = @sar.linked_items(:root)
    assert list
    assert list.is_a?(Array), "was {list.class} not a Array"
  end
  
  def test047_linked_item_root
    @sar.use_live = false
    list = @sar.linked_items(:root)
    assert list
    assert list.is_a?(Array), "was {list.class} not a Array"
  end

   def test048_conditions
    sar = CrossTab.new({:name=>'test032',:description=>'sssss'})
    assert sar.save , sar.errors.full_messages().join('\n')
    assert sar.add_columns(ProcessInstance.find(:first))
    sar.date_from =Date.civil(2006,1,1)
    sar.date_to= Date.civil(2010,1,1)
    assert sar.conditions
  end

  def test049_to_sql_date
    sar = CrossTab.new({:name=>'test032',:description=>'sssss'})
    date1 = sar.to_sql_date("1999-12-31")    
    date2 = sar.to_sql_date(Date.civil(1999,12,31))
    assert date1
    assert_equal "to_date('1999-12-31','YYYY-MM-DD')",date1    
    assert_equal date1,date2
  end
  
  
  def test050_filter
    sar = CrossTab.new({:name=>'test032',:description=>'sssss'})
    assert sar.save , sar.errors.full_messages().join('\n')
    assert sar.add_columns(Parameter.find(:first))
    sar.reload
    assert_equal 1, sar.columns.size
    column = sar.columns[0]
    sar.filter({:filters=>{column.id =>{"operator"=>"=","value"=>"1"}}})
    sar.reload
    assert_equal 1, sar.filters.size
  end
  
  def test051_as_reference
    sar = CrossTab.new({:name=>'test051',:description=>'sssss'})
    assert sar.save , sar.errors.full_messages().join('\n')
    assert sar.add_columns(Parameter.find(3))
    assert sar.add_columns(Parameter.find(9))
    sar.reload
    assert_equal 2, sar.columns.size
    join = sar.joins.as_reference(Parameter.find(3),Parameter.find(9))
    assert_ok join
    assert join.to_s
  end

  def test052_as_parent
    sar = CrossTab.new({:name=>'test052',:description=>'sssss'})
    assert sar.save , sar.errors.full_messages().join('\n')
    assert sar.add_columns(Parameter.find(3))
    assert sar.add_columns(Parameter.find(9))
    sar.reload
    assert_equal 2, sar.columns.size
    join = sar.joins.as_parent(Parameter.find(3),Parameter.find(9))
    assert_ok join
    assert join.to_s
  end

  def test053_as_child
    sar = CrossTab.new({:name=>'test053',:description=>'sssss'})
    assert sar.save , sar.errors.full_messages().join('\n')
    assert sar.add_columns(Parameter.find(3))
    assert sar.add_columns(Parameter.find(9))
    sar.reload
    assert_equal 2, sar.columns.size
    join = sar.joins.as_child(Parameter.find(3),Parameter.find(9))
    assert_ok join
    assert join.to_s
  end

  def test_is_dictionary
    assert_dictionary_lookup(CrossTab)
  end

end
