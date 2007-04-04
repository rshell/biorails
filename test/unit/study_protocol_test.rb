require File.dirname(__FILE__) + '/../test_helper'

class StudyProtocolTest < Test::Unit::TestCase
  fixtures :study_protocols

	NEW_STUDY_PROTOCOL = {:name => 'test'}	# e.g. {:name => 'Test StudyProtocol', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w(name ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = study_protocols(:first)
  end

  def test_raw_validation
    study_protocol = StudyProtocol.new
    if REQ_ATTR_NAMES.blank?
      assert study_protocol.valid?, "StudyProtocol should be valid without initialisation parameters"
    else
      # If StudyProtocol has validation, then use the following:
      assert !study_protocol.valid?, "StudyProtocol should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert study_protocol.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_study_protocol = NEW_STUDY_PROTOCOL.clone
			tmp_study_protocol.delete attr_name.to_sym
			study_protocol = StudyProtocol.new(tmp_study_protocol)
			assert !study_protocol.valid?, "StudyProtocol should be invalid, as @#{attr_name} is invalid"
    	assert study_protocol.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_study_protocol = StudyProtocol.find(:first)
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		study_protocol = StudyProtocol.new(NEW_STUDY_PROTOCOL.merge(attr_name.to_sym => current_study_protocol[attr_name]))
			assert !study_protocol.valid?, "StudyProtocol should be invalid, as @#{attr_name} is a duplicate"
    	assert study_protocol.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

