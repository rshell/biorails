require File.dirname(__FILE__) + '/../test_helper'
require 'data_formats_controller'

# Re-raise errors caught by the controller.
class DataFormatsController; def rescue_action(e) raise e end; end

class DataFormatsControllerTest < Test::Unit::TestCase
  fixtures :data_formats

	NEW_DATA_FORMAT = {}	# e.g. {:name => 'Test DataFormat', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = DataFormatsController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = data_formats(:first)
		@first = DataFormat.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'data_formats/component'
    data_formats = check_attrs(%w(data_formats))
    assert_equal DataFormat.find(:all).length, data_formats.length, "Incorrect number of data_formats shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'data_formats/component'
    data_formats = check_attrs(%w(data_formats))
    assert_equal DataFormat.find(:all).length, data_formats.length, "Incorrect number of data_formats shown"
  end

  def test_create
  	data_format_count = DataFormat.find(:all).length
    post :create, {:data_format => NEW_DATA_FORMAT}
    data_format, successful = check_attrs(%w(data_format successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal data_format_count + 1, DataFormat.find(:all).length, "Expected an additional DataFormat"
  end

  def test_create_xhr
  	data_format_count = DataFormat.find(:all).length
    xhr :post, :create, {:data_format => NEW_DATA_FORMAT}
    data_format, successful = check_attrs(%w(data_format successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal data_format_count + 1, DataFormat.find(:all).length, "Expected an additional DataFormat"
  end

  def test_update
  	data_format_count = DataFormat.find(:all).length
    post :update, {:id => @first.id, :data_format => @first.attributes.merge(NEW_DATA_FORMAT)}
    data_format, successful = check_attrs(%w(data_format successful))
    assert successful, "Should be successful"
    data_format.reload
   	NEW_DATA_FORMAT.each do |attr_name|
      assert_equal NEW_DATA_FORMAT[attr_name], data_format.attributes[attr_name], "@data_format.#{attr_name.to_s} incorrect"
    end
    assert_equal data_format_count, DataFormat.find(:all).length, "Number of DataFormats should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	data_format_count = DataFormat.find(:all).length
    xhr :post, :update, {:id => @first.id, :data_format => @first.attributes.merge(NEW_DATA_FORMAT)}
    data_format, successful = check_attrs(%w(data_format successful))
    assert successful, "Should be successful"
    data_format.reload
   	NEW_DATA_FORMAT.each do |attr_name|
      assert_equal NEW_DATA_FORMAT[attr_name], data_format.attributes[attr_name], "@data_format.#{attr_name.to_s} incorrect"
    end
    assert_equal data_format_count, DataFormat.find(:all).length, "Number of DataFormats should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	data_format_count = DataFormat.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal data_format_count - 1, DataFormat.find(:all).length, "Number of DataFormats should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	data_format_count = DataFormat.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal data_format_count - 1, DataFormat.find(:all).length, "Number of DataFormats should be one less"
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
