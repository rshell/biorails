require File.dirname(__FILE__) + '/../test_helper'
require  "calendar_controller"

class CalendarController; def rescue_action(e) raise e end; end

class CalendarControllerTest < Test::Unit::TestCase

  # Replace this with your real tests.
  def setup
    @controller = CalendarController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:current_project_id] = 2
    @request.session[:current_user_id] = 3
    @folder = Project.find(2).folder
  end
  
  def test_ok
    assert @folder
    assert @folder.id
  end
  
 def test_calendar_as_html
    get :show,:id=>@folder.id
    assert_response :success
  end
  
  def test_calendar_as_json
    get :show,{:format=>'json',:id=>@folder.id}
    assert_response :success
  end

  def test_calendar_as_js
    get :show,{:id=>@folder.id,:format=>'js'}
    assert_response :success
  end

  def test_get_gantt
    get :gantt,{:id=>@folder.id}
    assert_response :success
  end

  def test_get_gantt_for_year_month
    get :gantt,{:id=>@folder.id,:year=>2008,:month=>3}
    assert_response :success
  end

  def test_get_gantt_for_year
    get :gantt,{:id=>@folder.id,:year=>2008}
    assert_response :success
  end


  def test_get_gantt_js
    get :gantt,{:id=>@folder.id,:format=>'js'}
    assert_response :success
  end   
end
