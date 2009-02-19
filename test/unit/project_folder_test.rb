require File.dirname(__FILE__) + '/../test_helper'

class ProjectFolderTest < BiorailsTestCase

  @@logger=Logger.new(STDOUT)
 

  def test_new
    item = ProjectFolder.new(:name=>'test')
    assert item.name
    assert item.summary   
    assert item.to_html 
  end
  
  def test_create_folder
    project = Project.find(1)
    folder  = project.folder('xxx')
    assert_ok folder
    assert folder.name =='xxx'
  end
  
  def test_add_folder
    assert folder = ProjectFolder.find_by_name('Project X')
    assert item = folder.add_folder("xxxx")
    folder.reload
    assert_ok item
    assert_equal "xxxx",item.name
    assert_equal folder.id,item.parent_id
    assert_equal folder.access_control_list_id, item.access_control_list_id
    assert_equal folder.project_id, item.project_id  
    assert folder.left_limit  < item.left_limit,  "left  should be between #{folder.left_limit}< #{item.left_limit} >#{folder.right_limit}"    
    assert folder.right_limit > item.left_limit,  "left  should be between #{folder.left_limit}< #{item.left_limit} >#{folder.right_limit}"      
    assert folder.left_limit  < item.right_limit, "right should be between #{folder.left_limit}< #{item.right_limit} >#{folder.right_limit}"    
    assert folder.right_limit > item.right_limit, "right should be between #{folder.left_limit}< #{item.right_limit} >#{folder.right_limit}"      

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
    assert user
    element = folder.add_reference(user.name,user)
    assert element
    assert_ok element
    assert_ok element.reference
    assert_equal element.reference , user
  end

  def test_add_text
    project = Project.find(1)
    assert_ok project
    folder  = project.folder('xxx3')
    assert_ok folder
    element = folder.add_content('name','body')
    assert_ok element
    assert element.name == 'name'
    assert element.to_html 
    assert_ok element
  end
  
  def test_add_asset_rails_jpg
    project=Project.find(1)
    folder=project.folders.find(:first)
    file = File.join(RAILS_ROOT,'test','fixtures','files','rails.png')
    item = folder.add_asset('rails.jpg',file,'image/png') 
    assert_ok item
    assert_ok item.asset
    assert item.image?
  end
  
  def test_pdf_creation
    project=Project.find(1)
    folder=project.folders.find(:first)
    file = File.join(RAILS_ROOT,'test','fixtures','files','rails.png')
    folder.add_asset('rails.jpg',file,'image/png') 
    filename=File.join('tmp',"#{folder.dom_id}.pdf")
    path = folder.make_pdf(filename)
    assert path,"got a file name"
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
     
  def test_summary
    folder=ProjectFolder.find(:first)
    assert folder.summary
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
