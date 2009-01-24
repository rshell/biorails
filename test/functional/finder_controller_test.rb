require File.dirname(__FILE__) + '/../test_helper'
require 'finder_controller'

# Re-raise errors caught by the controller.
class FinderController; def rescue_action(e) raise e end; end

class FinderControllerTest < Test::Unit::TestCase
  def setup
    @controller = FinderController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 1
    @request.session[:current_user_id] = 3
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_get_search_as_html
    get :search,{:query=>'moose'}
    assert_response :success
  end

  def test_get_search_as_html2
    get :search,{:query=>'task'}
    assert_response :success
  end

  def test_get_search_as_js
    get :search,{:query=>'moose',:format=>'js'}
    assert_response :success
  end

  def test_get_search_as_xml
    get :search,{:query=>'moose',:format=>'xml'}
    assert_response :success
  end

  def test_clipboard_as_html
    get :clipboard
    assert_response :success
  end
  
  def test_clipboard_as_js
    get :clipboard,:format=>'js'
    assert_response :success
  end
  
  def test_clipboard_as_html
    get :clear_clipboard
    assert_response :success
  end

  def test_clipboard_as_js
    get :clear_clipboard,:format=>'js'
    assert_response :success
  end

  def test_add_to_clipboard_as_html
    e = ProjectElement.find(:first)
    assert e ,'Need a data element for this test'
    get :add_clipboard,{:id=>e.id},@session
    assert_response :success
  end
  
  def test_add_to_clipboard_as_js
    e = ProjectElement.find(:first)
    assert e ,'Need a data element for this test'
    get :add_clipboard,{:id=>e.id,:format=>'js'}
    assert_response :success
  end
  
   def test_remote_to_clipboard_as_html
    e = ProjectElement.find(:first)
    assert e ,'Need a data element for this test'
    get :remove_clipboard,{:id=>e.id},@session
    assert_response :success
  end

  def test_remote_to_clipboard_as_js
    e = ProjectElement.find(:first)
    assert e ,'Need a data element for this test'
    get :remove_clipboard,{:id=>e.id, :format=>'js'}
    assert_response :success
  end
end
