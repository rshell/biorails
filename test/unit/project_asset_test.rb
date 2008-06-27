require File.dirname(__FILE__) + '/../test_helper'

class ProjectAssetTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :project_assets
  ## Biorails::Dba.import_model :project_elements
  ## Biorails::Dba.import_model :projects

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_new
    item = ProjectAsset.new(:name=>'test')
    assert item.name
    assert item.summary  
    assert item.description  
    assert item.to_html 
  end
  
  def test_has_file_to_upload
     assert_not_nil fixture_file_upload('/files/rails.png', 'image/png')
  end
  
  def test_build
      project = Project.find(:first)
      file = fixture_file_upload('/files/rails.png', 'image/png')
      asset = ProjectAsset.build(:name=>'test', :uploaded_data=>file,:project_id=>project.id,:position=>'1')
      #asset.uploaded_data = file
      asset.project =project
      assert asset.valid?
      assert asset.save
  end  

  def test_update

  end
  
  def test_word_asset
     project = Project.find(:first)
     file = ActionController::TestUploadedFile.new(Test::Unit::TestCase.fixture_path+'/files/moose_origami.doc', 'application/word') 
     assert !file.nil?
     asset = ProjectAsset.build(:name=>'test2', :uploaded_data=>file,:project_id=>project.id,:position=>'1')
     assert asset.valid?, asset.errors.full_messages().to_sentence   
     assert asset.save  
  end

  def test_find
    item = ProjectAsset.find(:first)
    assert item
    assert item.name
    assert item.content_type
    assert item.to_html    
    assert item.signature
    assert item.filename
    assert item.image?
    assert item.icon
    assert item.asset.mime_type
  end 
  
  def test_pdf_asset
     file = ActionController::TestUploadedFile.new(Test::Unit::TestCase.fixture_path+'/files/Fitting.pdf', 'application/pdf') 
     asset = ProjectAsset.new
     asset.title="tests"
     asset.project = Project.find(:first)
     asset.uploaded_data = file  
     asset.valid?
     asset.save     
  end
  
  def test_image_asset
     file = ActionController::TestUploadedFile.new(Test::Unit::TestCase.fixture_path+'/files/rails.png', 'image/png') 
     asset = ProjectAsset.new
     asset.title="tests"
     asset.project = Project.find(:first)
     asset.uploaded_data = file  
     asset.valid?
     asset.save     
  end
  

end
