require File.dirname(__FILE__) + '/../test_helper'
require 'test/unit'

class TaskBuildTest < Test::Unit::TestCase

  def setup
    @model = Task
    @first = @model.find(:first)
    @parameter_role = ParameterRole.find(:first)
    @protocol = AssayProcess.find(:first)
    @data_element = DataElement.find(33)
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
    item = context1.item("Concentration")
    assert_equal "mM",item.parameter.display_unit
    item.value = "10"
    correct_value = item.value
    assert item.save, "item1 Concentration save failed"        

    item = context2.item("Concentration")
    item.value = "10 mM"
    assert item.to_s,"10 mM"
    assert item.save, "item2 Concentration save failed"        
    correct_value2 = item.value
   
    task = Task.find(task.id)
    assert_equal correct_value,  task.item(context1.label,"Concentration").to_unit , "failed 1 #{correct_value} != #{task.item(context1.label,"Concentration")}"
    assert_equal "10 mM".to_unit,task.item(context2.label,"Concentration").to_unit , "failed 2 10 mM != #{task.item(context1.label,"Concentration")}"
  end


  #
  # create a date parameter
  #
  def create_date_parameter(name, parameter_context, parameter_role)
    assert_ok data_format = DataFormat.create(:name=>"date_format_#{name}",
      :description=>'date',
      :data_type_id=>3,
      :format_sprintf=>'%Y-%m-%d')

    assert_ok parameter_type = ParameterType.create(:name=>"date_type_#{name}",
      :description=>'text',
      :data_type_id=>data_format.data_type_id)

    assert_ok assay_parameter = AssayParameter.create(:name=> parameter_type.name,
      :description=>parameter_type.description,
      :parameter_type_id => parameter_type.id,
      :parameter_role_id => parameter_role.id,
      :assay_id => parameter_context.process.protocol.assay.id,
      :data_type_id=>parameter_type.data_type_id,
      :data_format_id=>data_format.id)

    assert_ok parameter = parameter_context.add_parameter(assay_parameter)
    return parameter
  end

  #
  # create a text parameter
  #
  def create_text_parameter(name, parameter_context, parameter_role)
    assert_ok data_format = DataFormat.create(:name=>"text_format_#{name}",
      :description=>'value',
      :data_type_id=>1)

    assert_ok parameter_type = ParameterType.create(:name=>"text_type_#{name}",
      :description=>'text',
      :data_type_id=>data_format.data_type_id)

    assert_ok assay_parameter = AssayParameter.create(:name=> parameter_type.name,
      :description=>parameter_type.description,
      :parameter_type_id => parameter_type.id,
      :parameter_role_id => parameter_role.id,
      :assay_id => parameter_context.process.protocol.assay.id,
      :data_type_id=>parameter_type.data_type_id,
      :data_format_id=>data_format.id)

    assert_ok parameter = parameter_context.add_parameter(assay_parameter)
    return parameter
  end

  #
  # Create a reference parameter
  #
  def create_reference_parameter(name, parameter_context, parameter_role)
    assert_ok parameter_type = ParameterType.create(:name=>"ref_type_#{name}",
      :description=>'reference',
      :data_concept_id => @data_element.data_concept_id,
      :data_type_id=>5)

    assert_ok assay_parameter =AssayParameter.create(:name=> parameter_type.name,
      :description=>parameter_type.description,
      :parameter_type_id => parameter_type.id,
      :parameter_role_id => parameter_role.id,
      :assay_id => parameter_context.process.protocol.assay.id,
      :data_type_id=>parameter_type.data_type_id,
      :data_element_id=>@data_element.id)

    assert_ok parameter = parameter_context.add_parameter(assay_parameter)
    return parameter
  end

  def create_numeric_parameter(name, parameter_context, parameter_role)
    assert_ok data_format = DataFormat.create(:name=>"value_format_#{name}",
      :description=>'value',
      :data_type_id=>2,
      :format_sprintf=>'%d')

    assert_ok parameter_type = ParameterType.create(:name=>"value_type_#{name}",
      :description=>'text',
      :data_type_id=>data_format.data_type_id)

    assert_ok assay_parameter = AssayParameter.create(:name=> parameter_type.name,
      :description=>parameter_type.description,
      :parameter_type_id => parameter_type.id,
      :parameter_role_id => parameter_role.id,
      :assay_id => parameter_context.process.protocol.assay.id,
      :data_type_id=>parameter_type.data_type_id,
      :data_format_id=>data_format.id)

    assert_ok parameter = parameter_context.add_parameter(assay_parameter)
    return parameter
  end

  #
  # Testing formula processing on a task value
  #
  def create_task
     @task = Task.find(:first)
     @experiment = @task.experiment
     @assay   = @experiment.assay
     @process_instance = @task.protocol.new_version
     @parameter_context = @process_instance.contexts[0]
     p1 = create_text_parameter("text",@parameter_context,@parameter_role)
     p2 = create_date_parameter("date",@parameter_context,@parameter_role)
     p3 = create_numeric_parameter("number",@parameter_context,@parameter_role)
     p4 = create_reference_parameter("reference",@parameter_context,@parameter_role)
     p5 = create_text_parameter("formula",@parameter_context,@parameter_role)
     p5.default_value = "=#{p4.name}.name"

    assert p5.save
    experiment = @first.experiment
    task = experiment.add_task(:protocol_version_id=>@process_instance.id)
    task.save
    
    assert_ok task
    task.populate
    @task_context = task.contexts[0]
    @task_text = @task_context.item(p1,"text")    
    assert @task_text.save

    @task_date = @task_context.item(p2,"1999-12-30")    
    assert @task_date.save

    @task_value = @task_context.item(p3,"12.34")    
    assert @task_value.save

    @task_reference = @task_context.item(p4,@task.name)    
    assert @task_reference.save

    @task_context.reload

    assert_ok @task_context
    assert @task_context.items.size >=4
  end

  def test_calculate
    create_task
    assert_equal "", @task_context.calculate("no formula",nil)
    assert_equal "",@task_context.calculate("no formula","")
    assert_equal "moose",@task_context.calculate("no formula","moose")

    assert_equal "passed",@task_context.calculate("=moose.dropping","passed")
    assert_equal "passed",@task_context.calculate("=moose.dropping","passed")

    # "=reference.property"
    reference_formula1 = "=#{@task_reference.parameter.name}.name"
    reference_value1 = @task_reference.value
    assert_equal reference_value1,@task_reference.object.name
    assert_equal reference_value1,@task_reference.object.send(:name)
    assert_equal @task_reference,@task_context.item(@task_reference.parameter)
    #
    assert_equal reference_value1,@task_context.calculate(reference_formula1,nil)
    assert_equal reference_value1,@task_context.calculate(reference_formula1,"")
    assert_equal reference_value1,@task_context.calculate(reference_formula1,"moose")

     # "=text.property"
    text_formula1 = "=#{@task_text.parameter.name}.upcase"
    text_value1 = @task_text.value.upcase

    assert_equal text_value1,@task_context.calculate(text_formula1,nil)
    assert_equal text_value1,@task_context.calculate(text_formula1,"")
    assert_equal text_value1,@task_context.calculate(text_formula1,"moose")

     # "=numeric.property"
    numeric_formula1 = "=#{@task_value.parameter.name}.hours"
    numeric_value1 = @task_value.value.hours.to_s

    assert_equal numeric_value1,@task_context.calculate(numeric_formula1,nil)
    assert_equal numeric_value1,@task_context.calculate(numeric_formula1,"")
    assert_equal numeric_value1,@task_context.calculate(numeric_formula1,"moose")

     # "= date.property"
    date_formula1 = "=#{@task_date.parameter.name}.wday"
    date_value1 = @task_date.value.wday.to_s

    assert_equal date_value1,@task_context.calculate(date_formula1,nil)
    assert_equal date_value1,@task_context.calculate(date_formula1,"")
    assert_equal date_value1,@task_context.calculate(date_formula1,"moose")

  end

  def test_task__recalculate
    create_task
    @task.recalculate
    assert 0,@task.errors.size
  end

  def test_task_context_recalculate
    create_task
    @task_context.recalculate
    assert 0, @task_context.errors.size
  end

  def test_task_view_formats
    create_task
    parameter_context = @task_context.definition
    ParameterContext.output_styles.each do |format|
      parameter_context.output_style = format
      assert parameter_context.save
      @task.reload
      html = @task.to_html(false)
      assert html
      assert html.size>100
      assert_equal [], html.grep("No such template ")
      assert_equal  [], html.grep("comparison of Fixnum with String failed")
    end
  end

end
