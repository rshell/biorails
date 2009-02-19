require File.dirname(__FILE__) + '/../test_helper'

class ProjectReferenceTest < BiorailsTestCase
  ## Biorails::Dba.import_model :project_elements

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_new
    folder=ProjectReference.new(:name=>'test')
    assert folder.name
    assert folder.summary    
    assert folder.to_html 
  end

  def test_create_reference
    folder=ProjectFolder.find(:first)
    item = DataFormat.find(1)
    reference = folder.add_reference("XXXXX",item)
    assert reference
    assert_equal reference.reference,item
    assert reference.valid?
    assert_equal "XXXXX",reference.name
    assert reference.icon
    assert reference.to_html
    assert reference.summary
  end

  def test_create_duplicate_name
    folder=ProjectFolder.find(:first)
    item = DataFormat.find(1)
    reference = folder.add_reference("XXXXX",item)
    assert reference
    assert reference.valid?
    reference2 = folder.add_reference("XXXXX",item)
    assert !reference2.valid?
  end

  def test_create_duplicate_reference
    folder=ProjectFolder.find(:first)
    item = DataFormat.find(1)
    reference = folder.add_reference("XXXXX",item)
    assert reference
    assert reference.valid?
    reference2 = folder.add_reference("XXXX2",item)
    assert reference2.valid?
  end

  
end
