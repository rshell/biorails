require File.dirname(__FILE__) + '/../test_helper'

class ProjectContentTest < BiorailsTestCase
  # ## Biorails::Dba.import_model :project_contents

  def setup
    # Retrieve ## Biorails::Dba.import_model via their name
    @model = ProjectContent
  end
  
  def test_new
    item = ProjectContent.new(:name=>'test')
    assert item.name
    assert item.summary  
  end
   
  def test_find
    first = @model.find(:first)
    assert first.id
    assert first.name
  end
    
  def test_has_name
    first = @model.find(:first)
    assert first.name 
    assert first.icon
    assert first.content    
  end

  def test_html_urls
    first = @model.find(:first)
    assert first.content
    list = first.content.html_urls
    assert_equal [],list
  end

    def test_html_urls2
    first = @model.find(:first)
    first.content.body_html = 'bla bla <a href="xx">test</a> bla bla <a href="yy">test</a> '
    list = first.content.html_urls
    assert_equal ["xx",'yy'],list
  end

  def test_html_summary
    first = @model.find(:first)
    assert first.content
    list = first.content.summary
    assert list
  end

  def test_to_html
    first = @model.find(:first)
    assert first.name 
    assert first.to_html   
  end
  
  def test_to_urls
    first = @model.find(:first)
    assert first.content.html_urls    
  end

  def test_rebuild_sets
    assert Content.rebuild_sets
  end

  def test_to_urls
    first = @model.find(:first)
    assert first.icon
  end

  def test_html
    first = @model.find(:first)
    assert first.html
  end

  def test_to_html
    first = @model.find(:first)
    assert first.to_html
  end
 
  def test_project_content_build
    folder = ProjectFolder.find(:first)
    element = folder.add_content('name',"test text")
    assert_equal "test text", element.content.body_html
    assert element.content.valid?
    assert element.save
    assert_ok element
  end
 
  def test_project_update_content
    first=@model.find(:first)
    first.update_content('this is a body')
    assert_equal first.name, first.content.name
    assert_equal 'this is a body', first.content.body_html
    assert first.content.valid?
    first.update_content("test text")
    assert_equal "test text", first.content.body_html
    assert first.content.valid?
    assert_ok first

  end
 
 
end
