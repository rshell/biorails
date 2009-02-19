require File.dirname(__FILE__) + '/../test_helper'

class DataFormatTest < BiorailsTestCase
  ## Biorails::Dba.import_model :data_formats
  NEW_DATA_FORMAT = {:name => 'Test DataFormat', :description => 'Dummy'} # unless defined?
  REQ_ATTR_NAMES 			 = %w(name description) #unless defined? # name of fields that must be present, e.g. %(name description)
  DUPLICATE_ATTR_NAMES = %w( name ) #unless defined?  # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve ## Biorails::Dba.import_model via their name
    @model = DataFormat
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

  def test_create_text_format_part_of_line
    format = DataFormat.new(:name=>'test2',
                            :description=>"test",
                            :data_type_id=>1,
                            :format_regex=>'[A-Z]*',
                            :format_sprintf=>'%s')
    assert_valid format
    val = format.parse("moose dropping")
    assert val.empty?    
    
    val = format.parse("XXXX")
    assert val
    assert val.is_a?(String) 
    assert_equal "XXXX",val
    assert format.format(val),"XXXX"
    
    val = format.parse("XXXXxxxxx")
    assert_equal "XXXX",val
    
    val = format.parse("XXXXxxxxxXXXX")
    assert_equal "XXXX",val
  end

  def test_create_text_format_whole_line
    format = DataFormat.new(:name=>'test2',
                            :description=>"test",
                            :data_type_id=>1,
                            :format_regex=>'^[A-Z]*$',
                            :format_sprintf=>'%s')
    assert_valid format
    val = format.parse("moose dropping")
    assert val.empty?    
    
    val = format.parse("XXXX")
    assert val
    assert val.is_a?(String) 
    assert_equal "XXXX",val
    assert format.format(val),"XXXX"
    
    val = format.parse("XXXXxxxxx")
    assert val.empty?    
    
    val = format.parse("XXXXxxxxxXXXX")
    assert val.empty?    
  end
  
  def test_create_date_format_iso
    format = DataFormat.new(:name=>'test1',
                            :description=>"test",
                            :data_type_id=>3,
                            :format_regex=>nil,
                            :format_sprintf=>'%Y-%m-%d')
    assert_valid format
    val = format.parse("moose dropping")
    assert val.empty?    
    val = format.parse("1999-01-30")
    assert val.is_a?(Date) 
    val2 = format.parse("1999-1-30")
    assert_equal val,val2
    assert_equal Date.civil(1999,1,30),val
    assert_equal format.format(val),"1999-01-30"
  end

  def test_create_date_format_usa
    format = DataFormat.new(:name=>'test1',
                            :description=>"test",
                            :data_type_id=>3,
                            :format_regex=>nil,
                            :format_sprintf=>"%m/%d/%Y")
    assert_valid format
    val = format.parse("moose dropping")
    assert val.empty?    
    val = format.parse("1/30/1999")
    assert val
    assert val.is_a?(Date) 
    assert_equal Date.civil(1999,1,30),val
    assert format.format(val),"1/30/1999"
    
    val = format.parse("9/11/1999")
    assert val
    assert val.is_a?(Date) 
    assert_equal Date.civil(1999,9,11),val
    assert_equal format.format(val),"09/11/1999"
  end

  def test_create_date_format_uk
    format = DataFormat.new(:name=>'test1',
                            :description=>"test",
                            :data_type_id=>3,
                            :format_regex=>nil,
                            :format_sprintf=>'%d-%m-%Y')
    assert_valid format
    val = format.parse("moose dropping")
    assert val.empty?    
    val = format.parse("30-1-1999")
    assert val
    assert val.is_a?(Date) 
    assert_equal Date.civil(1999,1,30),val
    assert format.format(val),"30-1-1999"
    
    val = format.parse("9-11-1999")
    assert val
    assert val.is_a?(Date) 
    assert_equal Date.civil(1999,11,9),val
    assert_equal format.format(val),"09-11-1999"
  end
  
  
  def test_create_integer_format_english
    format = DataFormat.new(:name=>'test1',
                            :description=>"test",
                            :data_type_id=>2,
                            :format_regex=>'([+-]?[0-9]+)',
                            :format_sprintf=>'%i')
    assert_valid format
    val = format.parse("moose dropping")
    assert val.empty?    
    val = format.parse("12")
    assert val
    assert_equal val,12
    val = format.parse("12.3433")
    assert val
    assert_equal val,12
    assert val.is_a?(Numeric) 
    assert format.format(val),"12"
  end

  def test_create_integer_format_euro
    format = DataFormat.new(:name=>'test1',
                            :description=>"test",
                            :data_type_id=>2,
                            :format_regex=>'([+-]?[0-9]+)',
                            :format_sprintf=>'%i')
    assert_valid format
    val = format.parse("moose dropping")
    assert val.empty?    
    val = format.parse("12")
    assert val
    assert_equal val,12
    val = format.parse("12,3433")
    assert val
    assert_equal val,12
    assert val.is_a?(Numeric) 
    assert format.format(val),"12"
  end

  def test_create_numeric_format_integer_with_unit
    format = DataFormat.create(:name=>'test1',
                            :description=>"test",
                            :data_type_id=>2,
                            :format_regex=>'([+-]?[0-9]+)',
                            :format_sprintf=>'%i')
    assert_ok format
    val = format.parse("moose dropping")
    assert val.empty?    
    val = format.parse("12.11222 mM")
    assert val
    assert_equal val,Unit.new("12 mM")
    assert val.is_a?(Unit)  
    assert_equal format.format(val),"12 mM"
  end

  # European decimal separator
  def test_create_numeric_format_european_integer_with_unit
    format = DataFormat.create(:name=>'test1',
                            :description=>"test",
                            :data_type_id=>2,
                            :format_regex=>'([+-]?[0-9]+)',
                            :format_sprintf=>'%i')
    assert_ok format
    val = format.parse("moose dropping")
    assert val.empty?    
    val = format.parse("12,11222 mM")
    assert val
    assert_equal val,Unit.new("12 mM")
    assert val.is_a?(Unit)  
    assert_equal format.format(val),"12 mM"

  end


   def test_create_numeric_format_english_float_with_unit
    format = DataFormat.create(:name=>'test1',
                            :description=>"test",
                            :data_type_id=>2,
                            :format_regex=>'([+-]?\d*[\.,]?\d+(?:[Ee][+-]?)?\d*)',
                            :format_sprintf=>'%g')
    assert_ok format
    val = format.parse("moose dropping")
    assert val.empty?    
    val = format.parse("12.1122 mM")
    assert val
    assert_equal val,Unit.new("12.1122 mM")
    assert val.is_a?(Unit)  
    assert_equal format.format(val),"12.1122 mM"

  end

   def test_create_numeric_format_european_float_with_unit
    format = DataFormat.create(:name=>'test1',
                            :description=>"test",
                            :data_type_id=>2,
                            :format_regex=>'([+-]?\d*[\.,]?\d+(?:[Ee][+-]?)?\d*)',
                            :format_sprintf=>'%g')
    assert_ok format
    val = format.parse("moose dropping")
    assert val.empty?    
    val = format.parse("12,1122 mM")
    assert val
    assert_equal val,Unit.new("12.1122 mM")
    assert val.is_a?(Unit)  
    assert_equal format.format(val),"12.1122 mM"

  end

 
  # Ensures all the required fields have been entered
  def test_validates_presence_of
    REQ_ATTR_NAMES.each do |attr_name|
      tmp_data_format = NEW_DATA_FORMAT.clone
      tmp_data_format.delete attr_name.to_sym
      data_format = DataFormat.new(tmp_data_format)
      assert !data_format.valid?, "DataFormat should be invalid, as @#{attr_name} is invalid"
      assert data_format.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
  end

  # #Check field validation
  def test_raw_validation
    data_format = DataFormat.new
    if REQ_ATTR_NAMES.blank?
      assert data_format.valid?, "DataFormat should be valid without initialisation parameters"
    else
      # If DataFormat has validation, then use the following:
      assert !data_format.valid?, "DataFormat should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert data_format.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

  # Checks to make sure there are no duplicate fields in the db, as defined in
  # DUPLICATE_ATTR_NAMES
  def test_duplicate
    current_data_format = DataFormat.find(:first)
    DUPLICATE_ATTR_NAMES.each do |attr_name|
      data_format = DataFormat.new(NEW_DATA_FORMAT.merge(attr_name.to_sym => current_data_format[attr_name]))
      assert !data_format.valid?, "DataFormat should be invalid, as @#{attr_name} is a duplicate"
      assert data_format.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
  end

  def test_is_dictionary
    assert_dictionary_lookup(DataFormat)
  end

end
