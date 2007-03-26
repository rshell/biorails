require File.dirname(__FILE__) + '/../test_helper'
require 'data_types_controller'

# Re-raise errors caught by the controller.
class DataTypesController; def rescue_action(e) raise e end; end

class DataTypesControllerTest < Test::Unit::TestCase
  fixtures :data_types

	NEW_DATA_TYPE = {}	# e.g. {:name => 'Test DataType', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = DataTypesController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = data_types(:first)
		@first = DataType.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'data_types/component'
    data_types = check_attrs(%w(data_types))
    assert_equal DataType.find(:all).length, data_types.length, "Incorrect number of data_types shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'data_types/component'
    data_types = check_attrs(%w(data_types))
    assert_equal DataType.find(:all).length, data_types.length, "Incorrect number of data_types shown"
  end

  def test_create
  	data_type_count = DataType.find(:all).length
    post :create, {:data_type => NEW_DATA_TYPE}
    data_type, successful = check_attrs(%w(data_type successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal data_type_count + 1, DataType.find(:all).length, "Expected an additional DataType"
  end

  def test_create_xhr
  	data_type_count = DataType.find(:all).length
    xhr :post, :create, {:data_type => NEW_DATA_TYPE}
    data_type, successful = check_attrs(%w(data_type successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal data_type_count + 1, DataType.find(:all).length, "Expected an additional DataType"
  end

  def test_update
  	data_type_count = DataType.find(:all).length
    post :update, {:id => @first.id, :data_type => @first.attributes.merge(NEW_DATA_TYPE)}
    data_type, successful = check_attrs(%w(data_type successful))
    assert successful, "Should be successful"
    data_type.reload
   	NEW_DATA_TYPE.each do |attr_name|
      assert_equal NEW_DATA_TYPE[attr_name], data_type.attributes[attr_name], "@data_type.#{attr_name.to_s} incorrect"
    end
    assert_equal data_type_count, DataType.find(:all).length, "Number of DataTypes should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	data_type_count = DataType.find(:all).length
    xhr :post, :update, {:id => @first.id, :data_type => @first.attributes.merge(NEW_DATA_TYPE)}
    data_type, successful = check_attrs(%w(data_type successful))
    assert successful, "Should be successful"
    data_type.reload
   	NEW_DATA_TYPE.each do |attr_name|
      assert_equal NEW_DATA_TYPE[attr_name], data_type.attributes[attr_name], "@data_type.#{attr_name.to_s} incorrect"
    end
    assert_equal data_type_count, DataType.find(:all).length, "Number of DataTypes should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	data_type_count = DataType.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal data_type_count - 1, DataType.find(:all).length, "Number of DataTypes should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	data_type_count = DataType.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal data_type_count - 1, DataType.find(:all).length, "Number of DataTypes should be one less"
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
