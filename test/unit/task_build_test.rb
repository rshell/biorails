require File.dirname(__FILE__) + '/../test_helper'
require 'test/unit'

class TaskBuildTest < Test::Unit::TestCase

  def setup
     @model = Task
     @first = @model.find(:first)
  end
  

#
# Add a task to the current experiment
# 1) created a named task with with default workflow
# 2) created a named task with a specific process
# 3) copy a existing task with all values
#
  def test_01_add_task
    experiment = @first.experiment
    task = experiment.add_task
    assert task.valid?, "valid "+task.errors.full_messages.to_sentence
    assert task.save, "save ok"
  end

  def test_02_add_task_with_name
    experiment = @first.experiment
    task = experiment.add_task(:name=>'fred')
    assert task.valid?, "valid "+task.errors.full_messages.to_sentence
    assert task.save, "save ok"
    assert task.name == 'fred'
  end
  
  def task_03_add_task_with_given_process
    experiment = @first.experiment
    process = ProtocolVersion.find(:first)
    assert !process.nil?
    task = experiment.add_task(:process => process)
    assert task.valid?, "valid "+task.errors.full_messages.to_sentence
    assert task.save, "save ok"    
  end
#
# Data entry within a task.
# 1) Add a new root context
# 2) Add a child context to current context
#
#
  def test_04_add_row_with_1st_context_definition
    experiment = @first.experiment
    task = experiment.add_task    
    assert task.valid?, "task not valid "+task.errors.full_messages.to_sentence
    assert task.save, "task save failed"
    definition = task.process.first_context
    context = task.add_context()  # add 1st root context definition
    assert context.valid?, "context not valid "+context.errors.full_messages.to_sentence
    assert context.save, "context save failed"        
    assert context.definition == definition, "failed to use 1st context"
  end
  
  def test_05_add_row_with_given_context_definition
    experiment = @first.experiment
    task = experiment.add_task    
    assert task.valid?, "task not valid "+task.errors.full_messages.to_sentence
    assert task.save, "task save failed"
    definition = task.process.contexts[0]
    context = task.add_context(definition)
    assert context.valid?, "context not valid "+context.errors.full_messages.to_sentence
    assert context.save, "context save failed"        
    assert context.definition == definition, "failed to use 1st context"
  end  
 
  def test_06_add_child_row_to_1st_context_definition
    experiment = @first.experiment
    task = experiment.add_task    
    assert task.valid?, "task not valid "+task.errors.full_messages.to_sentence
    assert task.save, "task save failed"
    root_definition = task.process.contexts[0]
    root_context = task.add_context(root_definition)
 
    definition = root_definition.children[0]
    assert definition, "Test process as no child contexts"
    context = root_context.add_context(definition)

    assert context.valid?, "context not valid "+context.errors.full_messages.to_sentence
    assert context.save, "context save failed"        
    assert context.definition == definition, "failed to use 1st context"
    
    context = root_context.add_context(definition)
    context = root_context.add_context(definition)
    context = root_context.add_context(definition)
    context = root_context.add_context(definition)
    context = root_context.add_context(definition)
    context = root_context.add_context(definition)
    context = root_context.add_context(definition)
    context = root_context.add_context(definition)
    context = root_context.add_context(definition)
    context = root_context.add_context(definition)
    assert context.valid?, "context not valid "+context.errors.full_messages.to_sentence
    assert context.save, "context save failed cant add lots of rows"        
 end

 def test_07_make_process_modifiable
    experiment = @first.experiment
    task = experiment.add_task    
    assert task.valid?, "task not valid "+task.errors.full_messages.to_sentence
    assert task.save, "task save failed"

    task = experiment.add_task    
    assert task.valid?, "task not valid "+task.errors.full_messages.to_sentence
    assert task.save, "task save failed"
    
    old_process = task.process 
    assert !task.flexible?, "Task should not be flexible yet as 2x copies in experiment"
    assert task.make_flexible
    assert task.flexible?, "task should now be flexible"          
    assert task.process != old_process, "has not changed process as expected"
    assert task.process.contexts.size == old_process.contexts.size, 'number of contexts should not changes'
    assert task.process.parameters.size == old_process.parameters.size, 'number of parameters should not changed'
 end   
 
 def test_08_modify_task_number_of_rows_in_context
    experiment = @first.experiment
    task = experiment.add_task    
    assert task.valid?, "task not valid "+task.errors.full_messages.to_sentence
    assert task.save, "task save failed"
    assert task.make_flexible
    assert task.flexible?, "task should now be flexible"          
    definition = task.process.first_context
    context = task.add_context(definition)
    context = task.add_context(definition)
    context = task.add_context(definition)
    context = task.add_context(definition)
    context = task.add_context(definition)
    context = task.add_context(definition)
    context = task.add_context(definition)
    
    assert context.valid?, "context not valid "+context.errors.full_messages.to_sentence
    assert context.save, "context save failed"        
    assert context.definition == definition, "failed to use 1st context"    
    assert task.context(context.label)==context, "can find context"
 end   
 
 def test_09_modify_task
    experiment = @first.experiment
    task = experiment.add_task    
    assert task.valid?, "task not valid "+task.errors.full_messages.to_sentence
    assert task.save, "task save failed"
    assert task.make_flexible
    assert task.flexible?, "task should now be flexible"
    parameter = experiment.assay.parameters.first
    assert parameter,"failed to find parameter"
    
    n1 = task.process.parameters.size+1
    n2 = task.process.first_context.parameters.size+1
    p =  task.process.first_context.add_parameter(parameter) 
    
    assert p.valid?, "task not valid "+p.errors.full_messages.to_sentence
    assert p.save, "parameter save failed"
    assert p.assay_parameter == parameter, "new parameter is not of the right type"
    assert n2 == task.process.first_context.parameters.count,"fail to increase context parameters collection by 1"
    assert n1 == task.process.parameters.count,"#{n1} == #{task.process.parameters.count} fail to increase process parameters collection by 1"
 end
 
  def test_10_add_values
    experiment = @first.experiment
    task = experiment.add_task    
    assert task.valid?, "task not valid "+task.errors.full_messages.to_sentence
    assert task.save, "task save failed"
    definition = task.process.contexts[0]
    context1 = task.add_context(definition)
    assert context1.save, "context1 save failed"        
    context2 = task.add_context(definition)
    assert context2.save, "context2 save failed"        
    context3 = task.add_context(definition)
    assert context3.save, "context3 save failed"        
    context4 = task.add_context(definition)
    assert context4.valid?, "context4 not valid "+context4.errors.full_messages.to_sentence
    assert context4.save, "context4 save failed"  
    
    item = context1.item("Concentration")
    item.value = "10"
    correct_value = item.value
    assert item.save, "item1 Concentration save failed"        

    item = context2.item("Concentration")
    item.value = "10 mM"
    assert item.save, "item2 Concentration save failed"        
    correct_value2 = item.value

    item = context3.item("Concentration")
    item.value = "10 uM"
    assert item.save, "item3 save failed"        
    
    item = context4.item("Concentration")
    item.value = "10 nM"
    assert item.valid?, "item4 not valid "+item.errors.full_messages.to_sentence
    assert item.save, "item4 save failed"        
    
    task = Task.find(task.id)
    assert task.item(context1.label,"Concentration").value == correct_value,"failed 1 #{correct_value} != #{task.item(context1.label,"Concentration")}"
    assert task.item(context2.label,"Concentration").value == "10 mM".to_unit,"failed 2 10 mM != #{task.item(context1.label,"Concentration")}"
    assert task.item(context3.label,"Concentration").value == "10 uM".to_unit,"failed 3 10 uM != #{task.item(context1.label,"Concentration")}"
    assert task.item(context4.label,"Concentration").value == "10 nM".to_unit,"failed 4 10 nM != #{task.item(context1.label,"Concentration")}"
  end
  
end
