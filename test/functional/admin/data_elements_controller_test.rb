require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/admin/data_elements_controller"

# Re-raise errors caught by the controller.
class Admin::DataElementsController; def rescue_action(e) raise e end; end

class Admin::DataElementsControllerTest < Test::Unit::TestCase

  def setup
    @controller = Admin::DataElementsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 2
    @request.session[:current_user_id] = 3
    @first = DataElement.find(:first)
    @data_system = DataSystem.find(:first)
    @data_concept = DataConcept.find(:first)
  end


   def test_index
    get :index
    assert_response :redirect
  end

  def test_list
    get :list,:id => @data_system.id
    assert_response :redirect
  end

    def test_export
    get :export
    assert_response :success
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
    post :create,:id => @data_concept.id, :data_element => {
         "name"=>"xfsfsf", "data_system_id"=>"1", "estimated_count"=>"3", 
        "description"=>"test", "content"=>"A,B,C",   "data_concept_id"=>"3", 
        "parent_id"=>"",  "style"=>"list"}
    assert_response :redirect
    assert_redirected_to :action => 'list'
    assert_equal num_data_elements+4 , DataElement.count   
  end
  
  def test_add 
    post :add, :id=>@first.id, :child=>{:name=>"D", :description=>"D"}
    assert_response :redirect
    assert_redirected_to :action => 'show'
  end

  def test_add_duplicate
    post :add, :id=>@first.id, :child=>{:name=>"D", :description=>"D"}
    assert_response :redirect
    assert assigns(:child)
    assert assigns(:child).valid?
    assert_redirected_to :action => 'show'
    post :add, :id=>@first.id, :child=>{:name=>"D", :description=>"D"}
    assert_response :redirect
    assert assigns(:child)
    assert !assigns(:child).valid?
    assert_redirected_to :action => 'show'
  end
  
  def test_create_failed
    num_data_elements = DataElement.count
    post :create,:id => @data_concept.id, :data_element => {}
    assert_response :success
    assert_template 'new'
    assert_equal num_data_elements , DataElement.count
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

  def test_select_model_element
    get :select, :id => ModelElement.find(1),:query=>'Test'
    assert_response :success
  end

  def test_select_list_element
    get :select, :id => ListElement.find(80),:query=>'Dose'
    assert_response :success
  end

  def test_choices_model_element
    get :choices, :id => ModelElement.find(1),:match=>'T'
    assert_response :success
  end

  def test_choices_list_element
    get :choices, :id => ListElement.find(80),:match=>'Do'
    assert_response :success
  end


end
