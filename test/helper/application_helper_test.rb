require File.dirname(__FILE__) + '/../test_helper'

# Re-raise errors caught by the controller.
class ApplicationHelperTest < TestHelper
  include ERB::Util
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::PrototypeHelper
  include ApplicationHelper

  def setup
    @controller=ApplicationController.new
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

  def test_link_to_assert
    html = link_to_object(ProjectAsset.find(:first))
    assert html.is_a?(String)
    assert html.size>0
  end

  def test_link_to_content
    html = link_to_object(ProjectContent.find(:first))
    assert html.is_a?(String)
    assert html.size>0
  end

  def test_link_to_folder
    html = link_to_object(ProjectFolder.find(:first))
    assert html.is_a?(String)
    assert html.size>0
  end

  def test_link_to_element
    html = link_to_object(ProjectElement.find(:first))
    assert html.is_a?(String)
    assert html.size>0
  end

  def test_link_to_project
    html = link_to_object(Project.find(:first))
    assert html.is_a?(String)
    assert html.size>0
  end

  def test_link_to_assay
    html = link_to_object(Assay.find(:first))
    assert html.is_a?(String)
    assert html.size>0
  end

  def test_link_to_task
    html = link_to_object(Task.find(:first))
    assert html.is_a?(String)
    assert html.size>0
  end

  def test_link_to_experiment
    html = link_to_object(Experiment.find(:first))
    assert html.is_a?(String)
    assert html.size>0
  end

  def test_link_to_request
    html = link_to_object(Request.find(:first))
    assert html.is_a?(String)
    assert html.size>0
  end

  def test_link_to_report
    html = link_to_object(Report.find(:first))
    assert html.is_a?(String)
    assert html.size>0
  end

  def test_link_to_request_service
    html = link_to_object(RequestService.find(:first))
    assert html.is_a?(String)
    assert html.size>0
  end

  def test_elements_to_json
    @items = Project.find(2).folder.elements
    html = elements_to_json_level(@items)
    assert html.is_a?(String)
    assert html.size>0
  end

  def test_elements_project_tree
    @items = Project.find(2).folder
    html = project_tree(@items)
    assert html.is_a?(String)
    assert html.size>0
  end
end