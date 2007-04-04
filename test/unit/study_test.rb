require File.dirname(__FILE__) + '/../test_helper'

class StudyTest < Test::Unit::TestCase
  fixtures :studies

	NEW_STUDY = {:name => 'Test Study', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w(name description) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w(name) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = studies(:first)
  end

  def test_raw_validation
    study = Study.new
    if REQ_ATTR_NAMES.blank?
      assert study.valid?, "Study should be valid without initialisation parameters"
    else
      # If Study has validation, then use the following:
      assert !study.valid?, "Study should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert study.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    study = Study.new(NEW_STUDY)
    assert study.valid?, "Study should be valid"
   	NEW_STUDY.each do |attr_name|
      assert_equal NEW_STUDY[attr_name], study.attributes[attr_name], "Study.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_study = NEW_STUDY.clone
			tmp_study.delete attr_name.to_sym
			study = Study.new(tmp_study)
			assert !study.valid?, "Study should be invalid, as @#{attr_name} is invalid"
    	assert study.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_study = Study.find(:first)
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		study = Study.new(NEW_STUDY.merge(attr_name.to_sym => current_study[attr_name]))
			assert !study.valid?, "Study should be invalid, as @#{attr_name} is a duplicate"
    	assert study.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
	
	def test_parameter_roles
	  s = Study.find(1)
	  assert s.parameter_roles.size>1
	end

	def test_parameter_type
	  s = Study.find(1)
	  assert s.parameter_types.size>1
	end

end

