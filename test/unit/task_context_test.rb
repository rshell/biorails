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
        assert row.to_hash
        assert row.items
        assert row.items.size = row.to_hash.size
        assert row.items.size = definition.parameters.size
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
    parameter = definition.parameters[0]
    
    context = task.add_context(definition)
    assert context
    assert context.save
    item = context.item(parameter)
    
    assert item
    assert item.parameter == parameter
    assert item.to_s == parameter.default_value
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
   
end
