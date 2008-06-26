require File.dirname(__FILE__) + '/../test_helper'

# Re-raise errors caught by the controller.
class ApplicationHelperTest < TestHelper
  include ActionView::Helpers::PrototypeHelper
  include ApplicationHelper
  def setup
    @controller=ApplicationController.new
     @request    = ActionController::TestRequest.new
      @response   = ActionController::TestResponse.new
      @request.session[:user_id]=nil
  end
  def test_version
    assert_match '7',version_no("a_V7")
    assert_match '0',version_no("a")
  end
  def test_docpath_returns_correct_text
    assert_match(/show pdf/ , docpath('../../test/fixtures/files/Fitting'))
    assert_match(/missing/ , docpath('Project_X/missing'))
  end
  def test_zippath_returns_correct_text
     assert_match(/show zip/ , zippath('../../test/fixtures/files/test'))
     assert_match(/missing/ , zippath('../../test/fixtures/files/missing'))
   end
  
  
  def test_error_messages_for
    @task = Task.new
    assert !@task.valid?
    html = error_messages_for(:task)
    assert html.is_a?(String)
    assert html.size>0
  end

  def test_display
    html = display(true)
    assert html.is_a?(String)
    assert html.size==0
    html = display(false)
    assert html.is_a?(String)
    assert html.size>0
  end
   
  def test_main_panel
    html = main_panel("test")
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_help_panel
    html = help_panel("test")
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_work_panel
    html =work_panel("test")
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_audit_panel
    html =  audit_panel("test")
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_actions_panel
    html = actions_panel("test")
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_tree_panel
    html = tree_panel("test")
    assert html.is_a?(String)
    assert html.size>0
  end

  def test_docpath
    html =docpath("test")
    assert html.is_a?(String)
    assert html.size>0
  end
  
  def test_zippath
    html =zippath("test")
    assert html.is_a?(String)
    assert html.size>0
  end
  
end