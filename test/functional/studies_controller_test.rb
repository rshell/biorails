require File.dirname(__FILE__) + '/../test_helper'
require 'studies_controller'

# Re-raise errors caught by the controller.
class StudiesController; def rescue_action(e) raise e end; end

class StudiesControllerTest < Test::Unit::TestCase
  fixtures :studies

	NEW_STUDY = {}	# e.g. {:name => 'Test Study', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = StudiesController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = studies(:first)
		@first = Study.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'studies/component'
    studies = check_attrs(%w(studies))
    assert_equal Study.find(:all).length, studies.length, "Incorrect number of studies shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'studies/component'
    studies = check_attrs(%w(studies))
    assert_equal Study.find(:all).length, studies.length, "Incorrect number of studies shown"
  end

  def test_create
  	study_count = Study.find(:all).length
    post :create, {:study => NEW_STUDY}
    study, successful = check_attrs(%w(study successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal study_count + 1, Study.find(:all).length, "Expected an additional Study"
  end

  def test_create_xhr
  	study_count = Study.find(:all).length
    xhr :post, :create, {:study => NEW_STUDY}
    study, successful = check_attrs(%w(study successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal study_count + 1, Study.find(:all).length, "Expected an additional Study"
  end

  def test_update
  	study_count = Study.find(:all).length
    post :update, {:id => @first.id, :study => @first.attributes.merge(NEW_STUDY)}
    study, successful = check_attrs(%w(study successful))
    assert successful, "Should be successful"
    study.reload
   	NEW_STUDY.each do |attr_name|
      assert_equal NEW_STUDY[attr_name], study.attributes[attr_name], "@study.#{attr_name.to_s} incorrect"
    end
    assert_equal study_count, Study.find(:all).length, "Number of Studys should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	study_count = Study.find(:all).length
    xhr :post, :update, {:id => @first.id, :study => @first.attributes.merge(NEW_STUDY)}
    study, successful = check_attrs(%w(study successful))
    assert successful, "Should be successful"
    study.reload
   	NEW_STUDY.each do |attr_name|
      assert_equal NEW_STUDY[attr_name], study.attributes[attr_name], "@study.#{attr_name.to_s} incorrect"
    end
    assert_equal study_count, Study.find(:all).length, "Number of Studys should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	study_count = Study.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal study_count - 1, Study.find(:all).length, "Number of Studys should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	study_count = Study.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal study_count - 1, Study.find(:all).length, "Number of Studys should be one less"
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
