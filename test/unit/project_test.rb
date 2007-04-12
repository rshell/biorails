require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < Test::Unit::TestCase
  fixtures :projects
  fixtures :users
  fixtures :studies

  def assert_ok(object)
     assert_not_nil object, ' Object is missing'
     assert object.errors.empty? , " #{object.class}.#{object.id} has errors: "+object.errors.full_messages().join(',')
     assert object.valid?,         " #{object.class}.#{object.id} not valid: "+object.errors.full_messages().join(',')
     assert !object.new_record?,   " #{object.class}:#{object} not saved"
  end
  
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test001_valid
     project = Project.new(:name=>'test1',:summary=>'sssss')
     assert project.valid? , project.errors.full_messages().join('\n')
  end
  
  def test002_duplicate_name
     project = Project.new(:name=>'test2',:summary=>'sssss')
     assert project.save , project.errors.full_messages().join('\n')
     project = Project.new(:name=>'test2',:summary=>'sssss')
     assert !project.valid? , "Should not allow duplicate name"
  end


  def test003_invalid
     project = Project.new
     assert !project.valid?  
     project = Project.new(:name=>'test3')
     assert !project.valid?  
     project = Project.new
     assert !project.valid?  
  end

  def test004_save
     project = Project.new(:name=>'test4',:summary=>'sssss')
     assert project.save , project.errors.full_messages().join('\n')
     assert_ok project
     
     assert project.folders.size==1, 'has a root folder'
     assert project.articles.size==0, 'has no articles'
     assert project.members.size==0, 'has one member'
     assert project.memberships.size==0, 'has one membership'
     assert project.owners.size==0, 'has one owner'
  end 
  
  
  def test005_folders
     project = Project.find(1)
     assert 0==project.folders.size
  end  

  def test006_notes
     project = Project.new(:name=>'test5',:summary=>'sssss')
     assert project.save , project.errors.full_messages().join('\n')
     assert_ok project

     study = Study.find(:first)
     assert_ok study
     
     folder = project.folder(study)
     assert_ok folder
     assert  project.folders.detect{|i|i==folder}     
     assert_not_nil project.folders(study) # folder for unstructed information linked to the object
  end  

  def test007_linked_to
     project = Project.find(:first)
     assert 0==project.folders.size
     assert 0==project.folders_for(Study).size # array of folders linked to a model type
     study = Study.find(:first)
     assert_ok study

     user = User.find(users(:rshell).id)
     assert_ok user

     folder = project.folder(study)
     assert_ok folder

     assert 1==project.folders.linked_to(Study).size # array of folders linked to a model type
     

  end  

  def test008_studies
     project = Project.find(1)
     assert 0==project.studies.size
  end  

  def test009_experiments
     project = Project.find(1)
     assert 0== project.experiments.size
  end  

end
