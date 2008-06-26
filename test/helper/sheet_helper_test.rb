require File.dirname(__FILE__) + '/../test_helper'
# Re-raise errors caught by the controller.
class SheetHelperTest < TestHelper
  include FormHelper 
  include SheetHelper 
  
  def setup
    Project.current = Project.find(2)
    User.current = User.find(3)
  end  
  
  def test_paramater_collection
    @items = Parameter.find(:all)
    html = paramater_collection(@items)
    assert html.is_a?(Array)
    assert html.size>0
  end

  def test_context_definition
    @items = ParameterContext.find(:all)
    for item in @items
      html = context_definition(item)
      assert html.is_a?(String)
      assert html.size>0
    end
  end

  def test_context_model
    @items = ParameterContext.find(:all)
    for item in @items
      html = context_model(item)
      assert html.is_a?(String)
      assert html.size>0
    end
  end
 
 def test_context_values
    assert @task_value = TaskValue.find(:first)
    assert @task = @task_value.task
    assert @definition =@task_value.context.definition
    html = context_values(@task,@definition)
    assert html.is_a?(String)
    assert html.size>0
  end

end
