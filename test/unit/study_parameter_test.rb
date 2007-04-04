require File.dirname(__FILE__) + '/../test_helper'

class StudyParameterTest < Test::Unit::TestCase
  fixtures :study_parameters

	NEW_STUDY_PARAMETER = {:name => 'Test StudyParameter', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w(name ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w(name ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = study_parameters(:first)
  end

  def test_new
    study_parameter = StudyParameter.new(NEW_STUDY_PARAMETER)
    assert study_parameter.valid?, "StudyParameter should be valid"
   	NEW_STUDY_PARAMETER.each do |attr_name|
      assert_equal NEW_STUDY_PARAMETER[attr_name], study_parameter.attributes[attr_name], "StudyParameter.@#{attr_name.to_s} incorrect"
    end
  end

  def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_study_parameter = NEW_STUDY_PARAMETER.clone
			tmp_study_parameter.delete attr_name.to_sym
			study_parameter = StudyParameter.new(tmp_study_parameter)
			assert !study_parameter.valid?, "StudyParameter should be invalid, as @#{attr_name} is invalid"
    	assert study_parameter.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
  end

 def test_duplicate
    current_study_parameter = StudyParameter.find(:first)
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		study_parameter = StudyParameter.new(NEW_STUDY_PARAMETER.merge(attr_name.to_sym => current_study_parameter[attr_name]))
			assert !study_parameter.valid?, "StudyParameter should be invalid, as @#{attr_name} is a duplicate"
    	assert study_parameter.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

