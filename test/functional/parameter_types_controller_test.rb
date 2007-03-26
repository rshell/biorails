require File.dirname(__FILE__) + '/../test_helper'
require 'parameter_types_controller'

# Re-raise errors caught by the controller.
class ParameterTypesController; def rescue_action(e) raise e end; end

class ParameterTypesControllerTest < Test::Unit::TestCase
  fixtures :parameter_types

	NEW_PARAMETER_TYPE = {}	# e.g. {:name => 'Test ParameterType', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = ParameterTypesController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = parameter_types(:first)
		@first = ParameterType.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'parameter_types/component'
    parameter_types = check_attrs(%w(parameter_types))
    assert_equal ParameterType.find(:all).length, parameter_types.length, "Incorrect number of parameter_types shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'parameter_types/component'
    parameter_types = check_attrs(%w(parameter_types))
    assert_equal ParameterType.find(:all).length, parameter_types.length, "Incorrect number of parameter_types shown"
  end

  def test_create
  	parameter_type_count = ParameterType.find(:all).length
    post :create, {:parameter_type => NEW_PARAMETER_TYPE}
    parameter_type, successful = check_attrs(%w(parameter_type successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal parameter_type_count + 1, ParameterType.find(:all).length, "Expected an additional ParameterType"
  end

  def test_create_xhr
  	parameter_type_count = ParameterType.find(:all).length
    xhr :post, :create, {:parameter_type => NEW_PARAMETER_TYPE}
    parameter_type, successful = check_attrs(%w(parameter_type successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal parameter_type_count + 1, ParameterType.find(:all).length, "Expected an additional ParameterType"
  end

  def test_update
  	parameter_type_count = ParameterType.find(:all).length
    post :update, {:id => @first.id, :parameter_type => @first.attributes.merge(NEW_PARAMETER_TYPE)}
    parameter_type, successful = check_attrs(%w(parameter_type successful))
    assert successful, "Should be successful"
    parameter_type.reload
   	NEW_PARAMETER_TYPE.each do |attr_name|
      assert_equal NEW_PARAMETER_TYPE[attr_name], parameter_type.attributes[attr_name], "@parameter_type.#{attr_name.to_s} incorrect"
    end
    assert_equal parameter_type_count, ParameterType.find(:all).length, "Number of ParameterTypes should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	parameter_type_count = ParameterType.find(:all).length
    xhr :post, :update, {:id => @first.id, :parameter_type => @first.attributes.merge(NEW_PARAMETER_TYPE)}
    parameter_type, successful = check_attrs(%w(parameter_type successful))
    assert successful, "Should be successful"
    parameter_type.reload
   	NEW_PARAMETER_TYPE.each do |attr_name|
      assert_equal NEW_PARAMETER_TYPE[attr_name], parameter_type.attributes[attr_name], "@parameter_type.#{attr_name.to_s} incorrect"
    end
    assert_equal parameter_type_count, ParameterType.find(:all).length, "Number of ParameterTypes should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	parameter_type_count = ParameterType.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal parameter_type_count - 1, ParameterType.find(:all).length, "Number of ParameterTypes should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	parameter_type_count = ParameterType.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal parameter_type_count - 1, ParameterType.find(:all).length, "Number of ParameterTypes should be one less"
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
