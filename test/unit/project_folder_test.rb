require File.dirname(__FILE__) + '/../test_helper'

class ProjectFolderTest < Test::Unit::TestCase

  @@logger=Logger.new(STDOUT)
 

  def test_new
    item = ProjectFolder.new(:name=>'test')
    assert item.name
    assert item.summary  
    assert item.description  
    assert item.to_html 
  end
  
  def test_create_folder
    project = Project.find(1)
    folder  = project.folder('xxx')
    assert_ok folder
    assert folder.name =='xxx'
  end

  def test_child_create_folder
    project = Project.find(1)
    folder  = project.folder('level1')
    assert_ok folder
    folder2 = folder.folder('level2')
    assert_ok folder2
    folder3 = folder2.folder('level3')
    assert_ok folder3   
    assert_equal project.id, folder2.project_id
    assert_equal folder2.parent_id, folder.id
    assert_equal folder3.parent_id, folder2.id
    assert_equal folder3.project_id, project.id
  end
 # 
 # Cant see why need to create hash on folder (performance killer)
 # Was tested for but never used
 # 
 # def test_folder_should_create_checksum
 #   project=Project.find(1)
 #   folder=project.folder('new')
 #    assert_not_nil folder.published_hash
 # end
  
  def test_add_model
    project = Project.find(1)
    folder  = project.folder('xxx2')
    assert_ok folder
    user = User.find(:first)
    element = folder.add_reference(user.name,user)
    assert element
    assert element.reference.name == user.name
    assert element.reference.id == user.id 
    assert_ok element
  end

  def test_add_text
    project = Project.find(1)
    assert_ok project
    folder  = project.folder('xxx3')
    assert_ok folder
    element = folder.add_content('name','title','body')
    assert_ok element
    assert element.content.title == 'title'
    assert element.name == 'name'
    assert element.to_html 
    assert_ok element
  end
  
  def test_should_not_create_version_when_versioning_is_turned_off
    project = Project.find(1)
    count=ProjectFolder.find(:all).size
    folder=project.folders.find(:first)
    folder.name='new name'
    folder.save
    assert_equal ProjectFolder.find(:all).size,count
  end
  

  def test_add_asset_rails_jpg
    project=Project.find(1)
    folder=project.folders.find(:first)
    file = File.join(RAILS_ROOT,'test','fixtures','files','rails.png')
    item = folder.add_asset(file,'rails.jpg','image/png') 
    assert_ok item
    assert_ok item.asset
    assert item.image?
  end
  
  def test_pdf_creation
    project=Project.find(1)
    folder=project.folders.find(:first)
    file = File.join(RAILS_ROOT,'test','fixtures','files','rails.png')
    folder.add_asset(file,'rails.jpg','image/png') 
    path = folder.make_pdf_for_signing
    assert path,"got a file name"
    assert File.exists?(File.join(folder.project_filepath, path + '.pdf')),"no file #{path}.pdf found"
    assert File.exists?(File.join(folder.project_filepath, path + '.zip')),"no file #{path}.zip found"
  end
  
  def test_make_pdf
    project=Project.find(2)
    folder=project.home
    assert folder,"no folder found"
    assert folder.elements.size>0, "folder has no elements"
    filename=File.join('tmp',"#{folder.dom_id}.pdf")
    assert folder.make_pdf(filename), "no return for make_pdf #{filename}"
    assert File.exists?(filename),"no file #{filename} found"
  end

  def test_make_pdf_for_signing
    project=Project.find(2)
    folder=project.home
    path = folder.make_pdf_for_signing
    assert File.exists?(File.join(folder.project_filepath, path + '.pdf')),"no file #{path}.pdf found"
    assert File.exists?(File.join(folder.project_filepath, path + '.zip')),"no file #{path}.zip found"
  end
    
  def test_versioning
    project=Project.find(1)
    folder=project.folders.find(:first)
    assert_equal 1, folder.new_published_version
    assert_equal 2, folder.new_published_version
  end
  
  def test_summary
    folder=ProjectFolder.find(:first)
    assert folder.summary
  end

  def test_description
    folder=ProjectFolder.find(:first)
    assert folder.description
  end
  
  def test_assets
    folder=ProjectFolder.find(:first)
    assert folder.assets    
  end

  def test_contents
    folder=ProjectFolder.find(:first)
    assert folder.contents 
  end

  def test_icon
    folder=ProjectFolder.find(:first)
    assert folder.icon
  end

  def test_to_html
    folder=ProjectFolder.find(:first)
    assert folder.to_html
  end
  


end
