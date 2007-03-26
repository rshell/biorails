require File.dirname(__FILE__) + '/../test_helper'
require 'study_stages_controller'

# Re-raise errors caught by the controller.
class StudyStagesController; def rescue_action(e) raise e end; end

class StudyStagesControllerTest < Test::Unit::TestCase
  fixtures :study_stages

	NEW_STUDY_STAGE = {}	# e.g. {:name => 'Test StudyStage', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = StudyStagesController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = study_stages(:first)
		@first = StudyStage.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'study_stages/component'
    study_stages = check_attrs(%w(study_stages))
    assert_equal StudyStage.find(:all).length, study_stages.length, "Incorrect number of study_stages shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'study_stages/component'
    study_stages = check_attrs(%w(study_stages))
    assert_equal StudyStage.find(:all).length, study_stages.length, "Incorrect number of study_stages shown"
  end

  def test_create
  	study_stage_count = StudyStage.find(:all).length
    post :create, {:study_stage => NEW_STUDY_STAGE}
    study_stage, successful = check_attrs(%w(study_stage successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal study_stage_count + 1, StudyStage.find(:all).length, "Expected an additional StudyStage"
  end

  def test_create_xhr
  	study_stage_count = StudyStage.find(:all).length
    xhr :post, :create, {:study_stage => NEW_STUDY_STAGE}
    study_stage, successful = check_attrs(%w(study_stage successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal study_stage_count + 1, StudyStage.find(:all).length, "Expected an additional StudyStage"
  end

  def test_update
  	study_stage_count = StudyStage.find(:all).length
    post :update, {:id => @first.id, :study_stage => @first.attributes.merge(NEW_STUDY_STAGE)}
    study_stage, successful = check_attrs(%w(study_stage successful))
    assert successful, "Should be successful"
    study_stage.reload
   	NEW_STUDY_STAGE.each do |attr_name|
      assert_equal NEW_STUDY_STAGE[attr_name], study_stage.attributes[attr_name], "@study_stage.#{attr_name.to_s} incorrect"
    end
    assert_equal study_stage_count, StudyStage.find(:all).length, "Number of StudyStages should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	study_stage_count = StudyStage.find(:all).length
    xhr :post, :update, {:id => @first.id, :study_stage => @first.attributes.merge(NEW_STUDY_STAGE)}
    study_stage, successful = check_attrs(%w(study_stage successful))
    assert successful, "Should be successful"
    study_stage.reload
   	NEW_STUDY_STAGE.each do |attr_name|
      assert_equal NEW_STUDY_STAGE[attr_name], study_stage.attributes[attr_name], "@study_stage.#{attr_name.to_s} incorrect"
    end
    assert_equal study_stage_count, StudyStage.find(:all).length, "Number of StudyStages should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	study_stage_count = StudyStage.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal study_stage_count - 1, StudyStage.find(:all).length, "Number of StudyStages should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	study_stage_count = StudyStage.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal study_stage_count - 1, StudyStage.find(:all).length, "Number of StudyStages should be one less"
    assert_template 'destroy.rjs'
  end

protected
	# Could be put in a Helper library and included at top of test class
  def check_attrs(attr_list)
    attrs = []
    attr_list.each do |attr_sym|
      attr = assigns(attr_sym.to_sym)
      assert_not_nil attr,       "Attribute @#{attr_sym} should not be nil"
      assert !attr.new_record?,  "Should have saved the @#{attr_sym} obj" if attr.class == ActiveRecord
      attrs << attr
    end
    attrs.length > 1 ? attrs : attrs[0]
  end
end
