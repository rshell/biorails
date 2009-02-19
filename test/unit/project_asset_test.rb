require File.dirname(__FILE__) + '/../test_helper'

class ProjectAssetTest < BiorailsTestCase
  ## Biorails::Dba.import_model :project_assets
  ## Biorails::Dba.import_model :project_elements
  ## Biorails::Dba.import_model :projects

  def setup
      @project = Project.current =Project.find(2)
      @user = User.current =User.find(3)
      @folder = @project.home

  end
  # Replace this with your real tests.
  def test_truth
    assert @project
    assert @user
    assert @folder
  end
  
  def test_new
    item = ProjectAsset.new(:name=>'test')
    assert item.name
    assert item.summary  
    assert item.to_html 
  end

  
  def test_buildfile
      file = fixture_file_upload('/files/rails.png', 'image/png')
      element = @folder.add_element(ElementType::FILE,{:name=>'test2',:file=>file,:content_type=>'image/png'})
      assert_ok element
      assert_equal element.project , @project
      assert_equal element.name , 'test2'
      assert element.asset
      assert element.asset.db_file 
  end  
  
  def test_unloaded_word_asset
     file = ActionController::TestUploadedFile.new(File.join(RAILS_ROOT,'test','fixtures','files','moose_origami.doc'), 'application/word')
     assert !file.nil?
     element = @folder.add_asset('test2',file)
     assert_ok element
  end

  def test_find
    item = ProjectAsset.find(:first)
    assert item
    assert item.name
    assert item.content_type
    assert item.to_html    
    assert item.signature
    assert item.filename
    assert item.icon
    assert item.asset.mime_type
  end 
  
  def test_pdf_unloaded_asset
     file = ActionController::TestUploadedFile.new(File.join(RAILS_ROOT,'test','fixtures','files','Fitting.pdf'), 'application/pdf')
     element = @folder.add_element(ElementType::FILE,{:name=>'test_pdf',:file=>file,:content_type=>'application/pdf'})
     assert_ok element
     assert element.asset
     assert element.asset.db_file 
  end
  
  def test_image_unloaded_asset
     file = ActionController::TestUploadedFile.new(File.join(RAILS_ROOT,'test','fixtures','files','rails.png'), 'image/png')
     element = @folder.add_element(ElementType::FILE,{:name=>'test_png',:file=>file,:content_type=>'image/png'})
     assert_ok element
     assert element.asset
     assert element.asset.db_file 
  end

  
  def test_with_raw_file
     file = File.new(File.join(RAILS_ROOT,'test','fixtures','files','rails.png'))
     element = @folder.add_element(ElementType::FILE,{:name=>'test_png3',:file=>file,:content_type=>'image/png'})
     assert_ok element
     assert element.asset
     assert element.asset.summary
     assert element.asset.size>0
     assert element.asset.db_file 
  end
  
end
