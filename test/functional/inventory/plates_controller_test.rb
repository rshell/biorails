require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/inventory/plates_controller"

# Re-raise errors caught by the controller.
class Inventory::PlatesController; def rescue_action(e) raise e end; end

class Inventory::PlatesControllerTest < Test::Unit::TestCase
  # fixtures :plates

  # fixtures :compounds
  # fixtures :users
  # fixtures :projects
  # fixtures :roles
  # fixtures :memberships
  # fixtures :role_permissions

  def setup
    @controller = Inventory::PlatesController.new
    @request    = ActionController::TestRequest.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @response   = ActionController::TestResponse.new
    @first = Plate.find(:first)
  end

	NEW_PLATE = {}	# e.g. {:name => 'Test Plate', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

  def test_component
    get :component
    assert_response :success
    assert_template 'plates/component'
    plates = check_attrs(%w(plates))
    assert_equal Plate.find(:all).length, plates.length, "Incorrect number of plates shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'plates/component'
    plates = check_attrs(%w(plates))
    assert_equal Plate.find(:all).length, plates.length, "Incorrect number of plates shown"
  end

  def test_create
  	plate_count = Plate.find(:all).length
    post :create, {:plate => NEW_PLATE}
    plate, successful = check_attrs(%w(plate successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal plate_count + 1, Plate.find(:all).length, "Expected an additional Plate"
  end

  def test_create_xhr
  	plate_count = Plate.find(:all).length
    xhr :post, :create, {:plate => NEW_PLATE}
    plate, successful = check_attrs(%w(plate successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal plate_count + 1, Plate.find(:all).length, "Expected an additional Plate"
  end

  def test_update
  	plate_count = Plate.find(:all).length
    post :update, {:id => @first.id, :plate => @first.attributes.merge(NEW_PLATE)}
    plate, successful = check_attrs(%w(plate successful))
    assert successful, "Should be successful"
    plate.reload
   	NEW_PLATE.each do |attr_name|
      assert_equal NEW_PLATE[attr_name], plate.attributes[attr_name], "@plate.#{attr_name.to_s} incorrect"
    end
    assert_equal plate_count, Plate.find(:all).length, "Number of Plates should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	plate_count = Plate.find(:all).length
    xhr :post, :update, {:id => @first.id, :plate => @first.attributes.merge(NEW_PLATE)}
    plate, successful = check_attrs(%w(plate successful))
    assert successful, "Should be successful"
    plate.reload
   	NEW_PLATE.each do |attr_name|
      assert_equal NEW_PLATE[attr_name], plate.attributes[attr_name], "@plate.#{attr_name.to_s} incorrect"
    end
    assert_equal plate_count, Plate.find(:all).length, "Number of Plates should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	plate_count = Plate.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal plate_count - 1, Plate.find(:all).length, "Number of Plates should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	plate_count = Plate.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal plate_count - 1, Plate.find(:all).length, "Number of Plates should be one less"
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
