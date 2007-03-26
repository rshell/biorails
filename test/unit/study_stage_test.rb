require File.dirname(__FILE__) + '/../test_helper'

class StudyStageTest < Test::Unit::TestCase
  fixtures :study_stages

	NEW_STUDY_STAGE = {}	# e.g. {:name => 'Test StudyStage', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = study_stages(:first)
  end

  def test_raw_validation
    study_stage = StudyStage.new
    if REQ_ATTR_NAMES.blank?
      assert study_stage.valid?, "StudyStage should be valid without initialisation parameters"
    else
      # If StudyStage has validation, then use the following:
      assert !study_stage.valid?, "StudyStage should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert study_stage.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    study_stage = StudyStage.new(NEW_STUDY_STAGE)
    assert study_stage.valid?, "StudyStage should be valid"
   	NEW_STUDY_STAGE.each do |attr_name|
      assert_equal NEW_STUDY_STAGE[attr_name], study_stage.attributes[attr_name], "StudyStage.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_study_stage = NEW_STUDY_STAGE.clone
			tmp_study_stage.delete attr_name.to_sym
			study_stage = StudyStage.new(tmp_study_stage)
			assert !study_stage.valid?, "StudyStage should be invalid, as @#{attr_name} is invalid"
    	assert study_stage.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_study_stage = StudyStage.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		study_stage = StudyStage.new(NEW_STUDY_STAGE.merge(attr_name.to_sym => current_study_stage[attr_name]))
			assert !study_stage.valid?, "StudyStage should be invalid, as @#{attr_name} is a duplicate"
    	assert study_stage.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

