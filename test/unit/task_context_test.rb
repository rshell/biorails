require File.dirname(__FILE__) + '/../test_helper'

class TaskContextTest < Test::Unit::TestCase
  
 def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = TaskContext
  end
  
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  
  def test_find()
    task = Task.find(:first)
    assert task.contexts
    assert task.contexts.count > 0
  end
  
  #
  # See if data items and hashes contains corrent number of columns
  #
  def test_get_grid()
    task =Task.find(:first)
    task.process.contexts.each  do |definition| 
      rows = task.contexts.matching(definition)
      rows.each do |row|
        assert row.to_hash, " Can Hash"
        assert row.items, " Has Items"
        assert((( row.items.size + 4 ) == row.to_hash.size) , "items == to_hash #{row.items.size}+4 == #{row.to_hash.size} ")
        assert row.items.values.all?{|i|definition.parameter(i.parameter)}
      end
    end    
  end
    
  def test_new
    first = @model.new
    assert first
    assert first.new_record?
    assert !first.valid?
  end

  
  def test_build_simple_context
    task = Task.find(:first)
    assert task
    definition = task.process.contexts[0]
    for parameter in definition.parameters
      context = task.add_context(definition)
      assert context
      assert context.save
      item = context.item(parameter)

      assert item
      assert_equal item.parameter,parameter
      assert item.to_s, "value to a task item should not be null"
      assert_equal item.to_s,parameter.default_value.to_s
    end
  end

  
  def test_build_full_context
    task = Task.find(:first)
    assert task
    definition = task.process.contexts[0]
    
    context = task.add_context(definition)
    assert context
    assert context.save
    
    definition.parameters.each do |parameter|
      item = context.item(parameter)
      assert item
      assert item.parameter == parameter   
    end
  end

  def test_update
    first = @model.find(:first)
    assert first.save
    assert !first.new_record?
    assert first.valid?
  end
  
  def test_has_label
    first = @model.find(:first)
    assert first.label    
  end

  def test_has_row_no
    first = @model.find(:first)
    assert first.row_no 
  end

  def test_has_definition
    first = @model.find(:first)
    assert first.definition
    assert first.definition.is_a?( ParameterContext)
  end
 
  def test_has_task
    first = @model.find(:first)
    assert first.task
    assert first.task.is_a?(Task)
  end

  def test_has_path
    first = @model.find(:first)
    assert first.path 
  end  

  def test_has_parameters
    first = @model.find(:first)
    assert first.parameters
    assert first.parameters.size > 0 
    assert first.parameters[0].is_a?(Parameter)
  end  

  def test_has_items
    first = @model.find(:first)
    assert first.items 
  end  

  def test_can_convert_to_hash
    first = @model.find(:first)
    assert first.to_hash
  end  

  def test_can_convert_to_xml
    first = @model.find(:first)
    assert first.to_xml
  end  
   
  def test_roots
    roots = TaskContext.roots
    assert roots.is_a?(Array)
    assert roots.size>0
    assert roots[0].parent_id.nil?
  end
  
  def test_children
    root= TaskContext.roots[0]
    assert root.is_a?(TaskContext)
    assert root.children.is_a?(Array)    
    assert root.children.count>0
  end

  def test_children
    root= TaskContext.roots[0]
    assert root.is_a?(TaskContext)
    assert root.children.is_a?(Array)    
    assert root.children.count>0
  end
  
  def test_build_full_set
    root= TaskContext.roots[0]
    assert root.is_a?(TaskContext)
    items = root.full_set    
    assert items.is_a?(Array)
    assert items.size>0
  end 
  
  def test_populate
    root= TaskContext.roots[0]
    root.populate    
  end
  
  def test_rebuild_sets
    TaskContext.rebuild_sets
    TaskContext.check_all 
  end
  
   def test_add_parameter
    task = Task.find(:first)
    task.make_flexible
    assert task
    definition = task.process
    num = definition.parameters.size    
    context = task.contexts[0]
    context.add_parameter(definition.parameters[0])
    definition.reload
    assert_equal  num+1,definition.parameters.size    
  end

   def test_add_assay_parameter
    task = Task.find(:first)
    task.make_flexible
    assert task
    definition = task.process
    num = definition.parameters.size    
    context = task.contexts[0]
    context.add_parameter(definition.parameters[0].assay_parameter)
    definition.reload
    assert_equal  num+1,definition.parameters.size    
  end

   def test_add_assay_parameter_by_name
    task = Task.find(:first)
    task.make_flexible
    assert task
    definition = task.process
    num = definition.parameters.size    
    context = task.contexts[0]
    context.add_parameter(definition.parameters[0].assay_parameter.name)
    definition.reload
    assert_equal  num+1,definition.parameters.size    
  end
  
  def test_to_a
    context = TaskContext.find(:first,:conditions=>'parent_id is not null')
    assert context.to_a    
  end  
  
  def test_child
    context = TaskContext.find(:first,:conditions=>'parent_id is not null')
    assert context
    assert context.path
    assert context.seq
  end 

  def test_child_append_copy
    context = TaskContext.find(:first,:conditions=>'parent_id is not null')
    assert context
    item = context.append_copy
    assert_ok item
  end 
  
end
