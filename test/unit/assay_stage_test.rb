require File.dirname(__FILE__) + '/../test_helper'

class AssayStageTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :assay_stages

	NEW_STUDY_STAGE =  {:name => 'Test AssayStage', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w(name) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w(name) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve ## Biorails::Dba.import_model via their name
    # @first = assay_stages(:first)
  end

  def test_raw_validation
    assay_stage = AssayStage.new
    if REQ_ATTR_NAMES.blank?
      assert assay_stage.valid?, "AssayStage should be valid without initialisation parameters"
    else
      # If AssayStage has validation, then use the following:
      assert !assay_stage.valid?, "AssayStage should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert assay_stage.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    assay_stage = AssayStage.new(NEW_STUDY_STAGE)
    assert assay_stage.valid?, "AssayStage should be valid"
   	NEW_STUDY_STAGE.each do |attr_name|
      assert_equal NEW_STUDY_STAGE[attr_name], assay_stage.attributes[attr_name], "AssayStage.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_assay_stage = NEW_STUDY_STAGE.clone
			tmp_assay_stage.delete attr_name.to_sym
			assay_stage = AssayStage.new(tmp_assay_stage)
			assert !assay_stage.valid?, "AssayStage should be invalid, as @#{attr_name} is invalid"
    	assert assay_stage.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_assay_stage = AssayStage.new(:name=>'test', :description=>'test')
    current_assay_stage.save
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		assay_stage = AssayStage.new(NEW_STUDY_STAGE.merge(attr_name.to_sym => current_assay_stage[attr_name]))
			assert !assay_stage.valid?, "AssayStage should be invalid, as @#{attr_name} is a duplicate."
    	assert assay_stage.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end

  def test_is_dictionary
    assert_dictionary_lookup(AssayStage)
  end

end

