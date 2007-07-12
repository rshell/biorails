require File.dirname(__FILE__) + '/../test_helper'

class ProjectFolderTest < Test::Unit::TestCase
  fixtures :projects
  fixtures :users
  fixtures :project_elements

  def assert_ok(object)
     assert_not_nil object, ' Object is missing'
     assert object.errors.empty? , " #{object.class}.#{object.id} has errors: "+object.errors.full_messages().join(',')
     assert object.valid?,         " #{object.class}.#{object.id} not valid: "+object.errors.full_messages().join(',')
     assert !object.new_record?,   " #{object.class}:#{object} not saved"
  end
  
# Replace this with your real tests.
  def test001_truth
    assert true
  end
  
  def test002_create_folder
    project = Project.find(1)
    folder  = project.folder('xxx')
    assert_ok folder

    assert folder.name =='xxx'
  end



  def test003_child_create_folder
    project = Project.find(1)
    folder  = project.folder('level1')
    assert_ok folder

    folder2 = folder.folder('level2')
    assert_ok folder2

    folder3 = folder2.folder('level3')
    assert_ok folder3

  end
  
    
  def test004_add_model
    project = Project.find(1)
    folder  = project.folder('xxx2')
    assert_ok folder

    user = User.find(:first)

    element = folder.add_reference(user.name,user)
    assert element

    assert element.reference.name == user.name
    assert element.reference.id == user.id
    
  end

  def test005_add_text
    project = Project.find(1)
    assert_ok project
    
    folder  = project.folder('xxx3')
    assert_ok folder
    
    element = folder.add_content('name','title','body')
    assert_ok element

    assert element.content.title == 'title'
    assert element.name == 'name'
    assert element.to_html == 'body'    
  end
  
end
