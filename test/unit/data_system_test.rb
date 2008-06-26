require File.dirname(__FILE__) + '/../test_helper'

class DataSystemsTest < Test::Unit::TestCase
  NEW_DATA_SYSTEM = {:name => 'Test DataSystem', :description => 'Dummy'} #unless defined?
	REQ_ATTR_NAMES 			 = %w(name description) #unless defined? # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( name ) # unless defined?  # name of fields that cannot be a duplicate, e.g. %(name description)

 def setup
    # Retrieve ## Biorails::Dba.import_model via their name
     @model = DataSystem
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
  # Ensures all the required fields have been entered
    def test_validates_presence_of
     	REQ_ATTR_NAMES.each do |attr_name|
  			tmp_data_system = NEW_DATA_SYSTEM.clone
  			tmp_data_system.delete attr_name.to_sym
  			data_system = DataSystem.new(tmp_data_system)
  			assert !data_system.valid?, "DataSystem should be invalid, as @#{attr_name} is invalid"
      	assert data_system.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
      end
     end

    #Check field validation 
    def test_raw_validation
      data_system = DataSystem.new
      if REQ_ATTR_NAMES.blank?
        assert data_system.valid?, "DataSystem should be valid without initialisation parameters"
      else
        # If DataSystem has validation, then use the following:
        assert !data_system.valid?, "DataSystem should not be valid without initialisation parameters"
        REQ_ATTR_NAMES.each {|attr_name| assert data_system.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
      end
    end

    # Checks to make sure there are no duplicate fields in the db, as defined in DUPLICATE_ATTR_NAMES
    def test_duplicate
      current_data_system = DataSystem.find(:first)
     	DUPLICATE_ATTR_NAMES.each do |attr_name|
     		data_system = DataSystem.new(NEW_DATA_SYSTEM.merge(attr_name.to_sym => current_data_system[attr_name]))
  			assert !data_system.valid?, "DataSystem should be invalid, as @#{attr_name} is a duplicate"
      	assert data_system.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
  		end
  	end 

end
