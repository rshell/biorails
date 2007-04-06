require File.dirname(__FILE__) + '/../test_helper'

class ProjectAssetTest < Test::Unit::TestCase
  fixtures :project_assets
  fixtures :project_elements
  fixtures :projects

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  
  def test_has_file_to_upload
     assert_not_nil fixture_file_upload('/files/rails.png', 'image/png')
  end
  
  def test_create
      project = Project.find(:first)
      file = fixture_file_upload('/files/rails.png', 'image/png')
      asset = ProjectAsset.new
      asset.uploaded_data = file
      asset.project =project

      assert asset.valid?

      assert asset.save
  end
  
  
  def test_word_asset
     file = ActionController::TestUploadedFile.new('test/fixtures/files/moose_origami.doc', 'application/word') 
     asset = ProjectAsset.new
     asset.title="tests"
     asset.project = Project.find(:first)
     asset.uploaded_data = file  
     asset.valid?
     asset.save     
  end

  def test_pdf_asset
     file = ActionController::TestUploadedFile.new('test/fixtures/files/Fitting.pdf', 'application/pdf') 
     asset = ProjectAsset.new
     asset.title="tests"
     asset.project = Project.find(:first)
     asset.uploaded_data = file  
     asset.valid?
     asset.save     
  end
  
  def test_image_asset
     file = ActionController::TestUploadedFile.new('test/fixtures/files/rails.png', 'image/png') 
     asset = ProjectAsset.new
     asset.title="tests"
     asset.project = Project.find(:first)
     asset.uploaded_data = file  
     asset.valid?
     asset.save     
  end
  
  def test_signature
     asset = ProjectAsset.find(:first)
     assert_not_nil asset, "found a record"
     
     sign1 = asset.signature
     assert_not_nil sign1, "has a signature"
     assert sign1 == asset.signature , "signature is consistant"     
  end

end
