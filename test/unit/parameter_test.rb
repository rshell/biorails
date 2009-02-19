require File.dirname(__FILE__) + '/../test_helper'

class ParameterTest < BiorailsTestCase

  # Replace this with your real tests.
  def setup
    # Retrieve ## Biorails::Dba.import_model via their name
    @model = Parameter
  end
  
  def test_truth
    assert true
  end
  
  def test_find
    first = @model.find(:first)
    assert first.id
    assert first.name
  end
  
  def test_new
    first = @model.new
    assert first
    assert first.new_record?
    assert !first.valid?
  end

    def test_new_test_parse
    first = @model.new
    assert_equal "xx",first.parse("xx")
  end

   def test_new_test_format
    first = @model.new
    assert_equal "xx",first.format("xx")
  end

  def test_new_test_with_queue
    first = @model.new
    first.queue = AssayQueue.find(:first)
    assert first.path(:world)     
  end
  
  def test_from_xml
    param1 = Parameter.find(:first)
    param2 = Parameter.from_xml(param1.to_xml)  
    assert_equal param1,param2
  end
  
  def test_reorder_columns
    context = ParameterContext.find(6)
    assert context.parameters.size>4
    param1 = context.parameters[0]
    param2 = context.parameters[1]
    param4 = context.parameters[3]
    assert param1.column_no<param2.column_no
    column_no = param1.after(param2)
    assert column_no
    column_no = param4.after(param2)
    assert column_no
  end

  def test_update
    first = @model.find(:first)
    assert first.save
    assert !first.new_record?
    assert first.valid?
  end
  
  def test_has_name
    first = @model.find(:first)
    assert first.name    
  end

  def test_has_description
    first = @model.find(:first)
    assert first.description    
  end

  def test_has_mask
    first = @model.find(:first)
    assert first.mask    
  end
  
  
  def test_has_assay
    first = @model.find(:first)
    assert first.assay     
  end

  def test_has_protocol
    first = @model.find(:first)
    assert first.protocol    
  end

  def test_has_process
    first = @model.find(:first)
    assert first.process     
  end
  
  def test_has_context
    first = @model.find(:first)
    assert first.context     
  end
  
  def test_generate_method_setter
    first = @model.find(:first)

    first.set('name','xxxx')
    assert first.name.to_s == 'xxxx'    
    
    first.set(:name,'xxxx')
    assert first.name.to_s == 'xxxx'    
  end
  
  def test_has_style
    first = @model.find(:first)
    assert first.style 
  end
  
  def test_has_element
    first = @model.find(:first,:conditions=>'data_element_id is not null')
    assert first.element   
    first = @model.find(:first,:conditions=>'data_element_id is null')
    assert !first.element   
  end

  def test_has_parameter_type
    first = @model.find(:first)
    assert first.type    
  end  

  def test_has_parameter_role
    first = @model.find(:first)
    assert first.role  
  end  

  def test_has_process
    first = @model.find(:first)
    assert first.process    
  end

  def test_storage_unit
    first = @model.find_by_data_type_id(2)
    assert first.storage_unit  
  end
  
  def test_based_on_assay_parameter
    first = @model.find(:first)
    assert first.assay_parameter  
  end  
  
  def test_to_xml
    first = @model.find(:first)
    assert first.to_xml    
  end

  def test_to_json
    first = @model.find(:first)
    assert first.to_json    
  end
    
  def test_parse_and_format_text
    format = DataFormat.new(:name=>'testText',
      :description=>"test",
      :data_type_id=>1,
      :format_regex=>'[A-Z]*',
      :format_sprintf=>'%s')
    assert_valid format  
    param = Parameter.find_by_data_type_id(1)
    param.data_format = format
    item = "X"
    value = param.parse(item)    
    assert_equal item,value
    assert_equal item,param.format(value)
    assert_equal item,param.format(item)
  end
  
  def test_parse_and_format_number_integer
    format = DataFormat.new(:name=>'testText',
      :description=>"test",
      :data_type_id=>2,
      :format_regex=>'[0-9]*',
      :format_sprintf=>'%i')
    assert_valid format  
    param = Parameter.find_by_data_type_id(2)
    param.data_format = format
    item = "10"
    value = param.parse(item)    
    assert_equal "10 mM".to_unit,value
    assert_equal item,param.format(value)
    assert_equal item,param.format(item)

  end

  def test_parse_and_format_number_float
    format = DataFormat.new(:name=>'testText',
      :description=>"test",
      :data_type_id=>2,
      :format_regex=>'[0-9]*',
      :format_sprintf=>'%g')
    assert_valid format  
    param = Parameter.find_by_data_type_id(2)
    param.data_format = format
    item_float = "10.2222"

    value = param.parse(item_float)    
    assert_equal "10 mM".to_unit,value
    assert_equal "10",param.format(value)
    assert_equal "10",param.format(item_float)
  end
  
  
  def test_parse_and_format_date
    format = DataFormat.new(:name=>'test1',
      :description=>"test",
      :data_type_id=>3,
      :format_regex=>nil,
      :format_sprintf=>'%Y-%m-%d')
    assert_valid format  
    param = Parameter.find(:first)
    param.data_format = format
    item = "1999-01-31"
    date = Date.civil(1999,1,31)
    value = param.parse(item)    
    assert_equal date,value
    assert_equal item,param.format(value)
    assert_equal item,param.format(item)
  end
    
end
