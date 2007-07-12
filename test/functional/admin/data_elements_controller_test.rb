require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/data_elements_controller'

# Re-raise errors caught by the controller.
class Admin::DataElementsController; def rescue_action(e) raise e end; end

class Admin::DataElementsControllerTest < Test::Unit::TestCase
  fixtures :data_elements
  fixtures :data_concepts
  fixtures :data_systems
  fixtures :data_formats
  fixtures :users
  fixtures :projects
  fixtures :roles
  fixtures :role_permissions

  def setup
    @controller = Admin::DataElementsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
    @first = DataElement.find(:first)
    @data_system = DataSystem.find(:first)
    @data_concept = DataConcept.find(:first)
  end


  def test_list
    get :list,:id => @data_system.id

    assert_response :redirect
  end

  def test_show
    get :show, :id => @first.id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:data_element)
    assert assigns(:data_element).valid?
  end

  def test_new
    get :new, :id => @data_concept.id

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:data_element)
  end

  def test_create
    num_data_elements = DataElement.count

    post :create,:id => @data_concept.id, :data_element => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_data_elements + 1, DataElement.count
  end

  def test_destroy
    assert_not_nil DataElement.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      DataElement.find(1)
    }
  end
end
