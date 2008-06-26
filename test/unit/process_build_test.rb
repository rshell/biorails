require File.dirname(__FILE__) + '/../test_helper'
require 'test/unit'

class ProcessBuildTest < Test::Unit::TestCase

  def setup
    @parameter_role = ParameterRole.find(:first)
    @protocol = AssayProcess.find(:first)
    @data_element = DataElement.find(33)
    @task = Task.find(:first)
    @experiment = @task.experiment
    @assay   = @experiment.assay
    @process_instance = @task.protocol.new_version
    @parameter_context = @process_instance.contexts[0] 
  end

  def test_setup
    assert_ok @protocol
    assert_ok @data_element
    assert_ok @assay
    assert_ok @process_instance
    assert_ok @parameter_context
  end

  
  def test_dates_with_iso_output_mask
    assert_ok data_format = DataFormat.create(:name=>'test_date',
      :description=>'date',
      :data_type_id=>3,
      :format_sprintf=>'%Y-%m-%d')

    assert_ok parameter_type = ParameterType.create(:name=>data_format.name,
      :description=>'date',
      :data_type_id=>data_format.data_type_id)

    assert_ok assay_parameter =AssayParameter.create(:name=> parameter_type.name,
      :description=>parameter_type.description,
      :parameter_type_id => parameter_type.id,
      :parameter_role_id => @parameter_role.id,
      :assay_id => @assay.id,
      :data_type_id=>parameter_type.data_type_id,
      :data_format_id=>data_format.id)

    assert_ok parameter = @parameter_context.add_parameter(assay_parameter)
    assert_equal parameter,@process_instance.parameters[0]
    
    assert_equal Date.civil(2001,1,21),parameter.parse('2001-1-21')
    assert_equal Date.civil(2001,1,21),parameter.parse('2001-01-21')
    assert_equal Date.civil(2001,12,31),parameter.parse('2001-12-31')
    assert_equal nil,parameter.parse('2001-1-32')
    assert_equal nil,parameter.parse('2001-13-1')
    assert_equal '2001-01-21',parameter.format(Date.civil(2001,1,21))
    
    new_task =   @experiment.add_task(:protocol_version_id=>@process_instance.id)
    assert_save_ok new_task
    new_task.populate
    assert_equal @parameter_context,new_task.contexts[0].definition
    assert_equal 1,new_task.contexts.size
    item = new_task.contexts[0].item(parameter)
    assert item.is_a?(TaskText), "should be a TaskText not #{item.class}"

    ok = new_task.contexts[0].set_value(parameter,'1999-1-31')
    assert_equal '1999-01-31',ok[:value]
    assert !ok[:error]
    new_task.reload
    assert "1999-01-31",item.to_s
    assert_equal nil,item.to_unit
    assert Date.civil(1999,1,31),item.value       

    ok = new_task.contexts[0].set_value(parameter,'moose')
    assert !ok[:value],ok[:value]
    assert ok[:errors],ok

    ok = new_task.contexts[0].set_value(parameter,'5')
    assert ok[:errors],ok
    assert !ok[:value],ok[:value]
  end
  
  
  def test_numeric_with_output_mask
    assert_ok data_format = DataFormat.create(:name=>'test_value',
      :description=>'value',
      :data_type_id=>2,
      :format_sprintf=>'%d')

    assert_equal "10 mM".to_unit,data_format.parse('10 mM')
    assert_equal "10.8 mM".to_unit,data_format.parse('10.8 mM')
    assert_equal "10.8 mM".to_unit,data_format.parse('10,8 mM')
    assert_equal 10.to_unit,data_format.parse('10')
    assert_equal 99.999.to_unit,data_format.parse('99.999')
    assert_equal 99.999.to_unit,data_format.parse('99,999')
    assert_equal nil,data_format.parse('moose world')    
   
    assert_ok parameter_type = ParameterType.create(:name=>data_format.name,
      :description=>'numeric',
      :data_type_id=>data_format.data_type_id)

    assert_ok assay_parameter =AssayParameter.create(:name=> parameter_type.name,
      :description=>parameter_type.description,
      :parameter_type_id => parameter_type.id,
      :parameter_role_id => @parameter_role.id,
      :assay_id => @assay.id,
      :data_type_id=>parameter_type.data_type_id,
      :data_format_id=>data_format.id)

    assert_ok parameter = @parameter_context.add_parameter(assay_parameter)

    assert_equal "10 mM".to_unit,parameter.parse('10 mM')
    assert_equal "10.323 mM".to_unit,parameter.parse('10.323 mM')
    assert_equal 10.1,parameter.parse('10.1')
    assert_equal "10 kg".to_unit,parameter.parse('10 kg')
    assert_equal "10 mM".to_unit,parameter.format('10 mM'.to_unit)    

    new_task =   @experiment.add_task(:protocol_version_id=>@process_instance.id)
    assert_save_ok new_task
    new_task.populate
    assert_equal @parameter_context,new_task.contexts[0].definition
    assert_equal 1,new_task.contexts.size

    ok = new_task.contexts[0].set_value(parameter,'10 mM')
    assert ok[:value]
    assert !ok[:errors]
    new_task.reload
    item = new_task.contexts[0].item(parameter)    
    assert item.is_a?(TaskValue), "should be a TaskText not #{item.class}"
    assert_ok item
    assert "10 mM",item.to_s
    assert "10 mM".to_unit,item.to_unit
    assert "10 mM".to_unit,item.value
     
  end
  
  
  def test_numeric_with_output_mask_and_dimension_length
    assert_ok data_format = DataFormat.create(:name=>'test_value',
      :description=>'value',
      :data_type_id=>2,
      :format_sprintf=>'%d')

    assert_equal "10 mM".to_unit,data_format.parse('10 mM')
    assert_equal 10.to_unit,data_format.parse('10')
    assert_equal 99.999.to_unit,data_format.parse('99.999')
    assert_equal nil,data_format.parse('moose world')    
   
    assert_ok parameter_type = ParameterType.create(:name=>data_format.name,
      :description=>'numeric',
      :storage_unit=>'length',
      :data_type_id=>data_format.data_type_id)

    assert_ok assay_parameter =AssayParameter.create(:name=> parameter_type.name,
      :description=>parameter_type.description,
      :parameter_type_id => parameter_type.id,
      :parameter_role_id => @parameter_role.id,
      :assay_id => @assay.id,
      :display_unit =>'cm',
      :data_type_id=>parameter_type.data_type_id,
      :data_format_id=>data_format.id)

    assert_ok parameter = @parameter_context.add_parameter(assay_parameter)

    assert_equal "0.1 m".to_unit,parameter.parse('10 cm')
    assert_equal "10.323 mm".to_unit,parameter.parse('10.323 mm')
    assert_equal "10.1 cm".to_unit,parameter.parse('10.1')
    assert_equal "10 kg".to_unit,parameter.parse('10 kg')
    assert_equal "10 mm",parameter.format('10 mm'.to_unit)    
    assert_equal "10",parameter.format('10 cm'.to_unit)    
    
    new_task =   @experiment.add_task(:protocol_version_id=>@process_instance.id)
    assert_save_ok new_task
    new_task.populate
    assert_equal @parameter_context,new_task.contexts[0].definition
    assert_equal 1,new_task.contexts.size
    item = new_task.contexts[0].item(parameter)
    assert item.is_a?(TaskValue), "should be a TaskValue not #{item.class}"

    ok = new_task.contexts[0].set_value(parameter,'1.232 mm')
    assert ok[:value]
    assert !ok[:errors]
    new_task.reload
    item = new_task.contexts[0].item(parameter)    
    assert item.is_a?(TaskValue), "should be a TaskValue not #{item.class}"
    assert_ok item
    assert "1.232 mm",item.to_s
    assert "1.232 mm".to_unit,item.to_unit
    assert "1.232 mm".to_unit,item.value

    ok = new_task.contexts[0].set_value(parameter,'2.34')
    assert ok[:value]
    assert !ok[:errors]
    new_task.reload
    item = new_task.contexts[0].item(parameter)    
    assert item.is_a?(TaskValue), "should be a TaskValue not #{item.class}"
    assert_ok item
    assert "2.34",item.to_s
    assert "2.34 cm".to_unit,item.to_unit
    assert "2.34 cm".to_unit,item.value    
  end
  
  
  def test_text_with_output_mask
    assert_ok data_format = DataFormat.create(:name=>'text_text',
      :description=>'value',
      :data_type_id=>1,
      :format_sprintf=>'%s')

    assert_equal "moose world",data_format.parse('moose world')
    assert_equal '1999-12-1',data_format.parse('1999-12-1')
    assert_equal "10 mM",data_format.parse('10 mM')
    assert_equal "10",data_format.parse('10')
   
    assert_ok parameter_type = ParameterType.create(:name=>data_format.name,
      :description=>'text',
      :data_type_id=>data_format.data_type_id)

    
    assert_ok assay_parameter =AssayParameter.create(:name=> parameter_type.name,
      :description=>parameter_type.description,
      :parameter_type_id => parameter_type.id,
      :parameter_role_id => @parameter_role.id,
      :assay_id => @assay.id,
      :data_type_id=>parameter_type.data_type_id,
      :data_format_id=>data_format.id)

    assert_equal '1999-12-1',assay_parameter.parse('1999-12-1')
    assert_equal "moose world",assay_parameter.parse('moose world')
    assert_equal "10 mM",assay_parameter.parse('10 mM')
   
    assert_ok parameter = @parameter_context.add_parameter(assay_parameter)

    assert_equal '1999-12-1',parameter.parse('1999-12-1')
    assert_equal "moose world",parameter.parse('moose world')
    assert_equal "10 mM",parameter.parse('10 mM')
    assert_equal "10 mM",parameter.parse('10 mM')
    assert_equal "10.323 mM",parameter.parse('10.323 mM')
    assert_equal "10.1",parameter.parse('10.1')
    assert_equal "10 kg",parameter.parse('10 kg')
    assert_equal "10 mM",parameter.format('10 mM')    
    assert_equal '2001-1-32',parameter.parse('2001-1-32')
  end    

  
  def test_text_with_no_masks
    assert_ok data_format = DataFormat.create(:name=>'text_text',
      :description=>'value',
      :data_type_id=>1)

    assert_equal "moose world",data_format.parse('moose world')
    assert_equal '1999-12-1',data_format.parse('1999-12-1')
    assert_equal "10 mM",data_format.parse('10 mM')
    assert_equal "10",data_format.parse('10')
   
    assert_ok parameter_type = ParameterType.create(:name=>data_format.name,
      :description=>'text',
      :data_type_id=>data_format.data_type_id)

    
    assert_ok assay_parameter =AssayParameter.create(:name=> parameter_type.name,
      :description=>parameter_type.description,
      :parameter_type_id => parameter_type.id,
      :parameter_role_id => @parameter_role.id,
      :assay_id => @assay.id,
      :data_type_id=>parameter_type.data_type_id,
      :data_format_id=>data_format.id)

    assert_equal '1999-12-1',assay_parameter.parse('1999-12-1')
    assert_equal "moose world",assay_parameter.parse('moose world')
    assert_equal "10 mM",assay_parameter.parse('10 mM')
   
    assert_ok parameter = @parameter_context.add_parameter(assay_parameter)

    assert_equal '1999-12-1',parameter.parse('1999-12-1')
    assert_equal "moose world",parameter.parse('moose world')
    assert_equal "10 mM",parameter.parse('10 mM')
    assert_equal "10 mM",parameter.parse('10 mM')
    assert_equal "10.323 mM",parameter.parse('10.323 mM')
    assert_equal "10.1",parameter.parse('10.1')
    assert_equal "10 kg",parameter.parse('10 kg')
    assert_equal "10 mM",parameter.format('10 mM')    
    assert_equal '2001-1-32',parameter.parse('2001-1-32')
  end    

  def test_url
    assert_ok data_format = DataFormat.create(:name=>'text_text',
      :description=>'value',
      :data_type_id=>1,
      :format_sprintf=>'%s')

    assert_ok parameter_type = ParameterType.create(:name=>data_format.name,
      :description=>'text',
      :data_type_id=>data_format.data_type_id)

    assert_ok assay_parameter_url =AssayParameter.create(:name=> parameter_type.name,
      :description=>parameter_type.description,
      :parameter_type_id => parameter_type.id,
      :parameter_role_id => @parameter_role.id,
      :assay_id => @assay.id,
      :data_type_id=>parameter_type.data_type_id,
      :data_format_id=>data_format.id)

    assert_ok parameter_url = @parameter_context.add_parameter(assay_parameter_url)

    assert_equal "http://192.168.1.10:3000/experiments/show/10121",parameter_url.parse('http://192.168.1.10:3000/experiments/show/10121')
    assert_equal 'http://192.168.1.10:3000/',parameter_url.parse('http://192.168.1.10:3000/')
    assert_equal "10 mM",parameter_url.parse('10 mM')
  end    
  
  
  def test_reference_type
    assert_ok parameter_type = ParameterType.create(:name=>'test_reference',
      :description=>'text',
      :data_concept_id => @data_element.data_concept_id,
      :data_type_id=>5)

    assert_ok assay_parameter_url =AssayParameter.create(:name=> parameter_type.name,
      :description=>parameter_type.description,
      :parameter_type_id => parameter_type.id,
      :parameter_role_id => @parameter_role.id,
      :assay_id => @assay.id,
      :data_type_id=>parameter_type.data_type_id,
      :data_element_id=>@data_element.id)

    assert_ok parameter = @parameter_context.add_parameter(assay_parameter_url)

    assert_equal @task,parameter.parse(@task.name)
    assert_equal @task.name,parameter.format(@task)

    new_task =   @experiment.add_task(:protocol_version_id=>@process_instance.id)
    assert_save_ok new_task
    new_task.populate
    assert_equal @parameter_context,new_task.contexts[0].definition
    assert_equal 1,new_task.contexts.size
    item = new_task.contexts[0].item(parameter)
    assert item.is_a?(TaskReference), "should be a TaskText not #{item.class}"

    ok = new_task.contexts[0].set_value(parameter,@task.name)
    assert_equal @task.name,ok[:value]
    assert !ok[:error]
    new_task.reload
    assert @task.name,item.to_s
    assert_equal nil,item.to_unit
    assert @task,item.value       
    
  end    

end
