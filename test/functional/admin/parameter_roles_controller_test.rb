require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/parameter_roles_controller'

# Re-raise errors caught by the controller.
class Admin::ParameterRolesController; def rescue_action(e) raise e end; end

class Admin::ParameterRolesControllerTest < Test::Unit::TestCase
  fixtures :parameter_roles

	NEW_PARAMETER_ROLE = {}	# e.g. {:name => 'Test ParameterRole', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = ParameterRolesController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = parameter_roles(:first)
		@first = ParameterRole.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'parameter_roles/component'
    parameter_roles = check_attrs(%w(parameter_roles))
    assert_equal ParameterRole.find(:all).length, parameter_roles.length, "Incorrect number of parameter_roles shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'parameter_roles/component'
    parameter_roles = check_attrs(%w(parameter_roles))
    assert_equal ParameterRole.find(:all).length, parameter_roles.length, "Incorrect number of parameter_roles shown"
  end

  def test_create
  	parameter_role_count = ParameterRole.find(:all).length
    post :create, {:parameter_role => NEW_PARAMETER_ROLE}
    parameter_role, successful = check_attrs(%w(parameter_role successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal parameter_role_count + 1, ParameterRole.find(:all).length, "Expected an additional ParameterRole"
  end

  def test_create_xhr
  	parameter_role_count = ParameterRole.find(:all).length
    xhr :post, :create, {:parameter_role => NEW_PARAMETER_ROLE}
    parameter_role, successful = check_attrs(%w(parameter_role successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal parameter_role_count + 1, ParameterRole.find(:all).length, "Expected an additional ParameterRole"
  end

  def test_update
  	parameter_role_count = ParameterRole.find(:all).length
    post :update, {:id => @first.id, :parameter_role => @first.attributes.merge(NEW_PARAMETER_ROLE)}
    parameter_role, successful = check_attrs(%w(parameter_role successful))
    assert successful, "Should be successful"
    parameter_role.reload
   	NEW_PARAMETER_ROLE.each do |attr_name|
      assert_equal NEW_PARAMETER_ROLE[attr_name], parameter_role.attributes[attr_name], "@parameter_role.#{attr_name.to_s} incorrect"
    end
    assert_equal parameter_role_count, ParameterRole.find(:all).length, "Number of ParameterRoles should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	parameter_role_count = ParameterRole.find(:all).length
    xhr :post, :update, {:id => @first.id, :parameter_role => @first.attributes.merge(NEW_PARAMETER_ROLE)}
    parameter_role, successful = check_attrs(%w(parameter_role successful))
    assert successful, "Should be successful"
    parameter_role.reload
   	NEW_PARAMETER_ROLE.each do |attr_name|
      assert_equal NEW_PARAMETER_ROLE[attr_name], parameter_role.attributes[attr_name], "@parameter_role.#{attr_name.to_s} incorrect"
    end
    assert_equal parameter_role_count, ParameterRole.find(:all).length, "Number of ParameterRoles should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	parameter_role_count = ParameterRole.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal parameter_role_count - 1, ParameterRole.find(:all).length, "Number of ParameterRoles should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	parameter_role_count = ParameterRole.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal parameter_role_count - 1, ParameterRole.find(:all).length, "Number of ParameterRoles should be one less"
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
