require File.dirname(__FILE__) + '/../../test_helper'
require "#{RAILS_ROOT}/app/controllers/admin/catalogue_controller"

# Re-raise errors caught by the controller.
class Admin::CatalogueController; def rescue_action(e) raise e end; end

class Admin::CatalogueControllerTest < Test::Unit::TestCase
  # # fixtures :parameter_types

	NEW_PARAMETER_TYPE = {}	# e.g. {:name => 'Test ParameterType', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = Admin::CatalogueController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
        @request.session[:current_project_id] = 1
        @request.session[:current_user_id] = 3
        @item = DataConcept.find(:first)
  end

  def test_truth
    assert true
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list
    assert_response :success
    assert_template 'list'
  end

  def test_show
    get :show, :id => @item.id
    assert_response :success
    assert_template 'show'
  end


  end
