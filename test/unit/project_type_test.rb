require File.dirname(__FILE__) + '/../test_helper'

class ProjectTypeTest < Test::Unit::TestCase

  # Replace this with your real tests.
  def test00_truth
    assert true
  end
  
  def test01_find_first
    assert ProjectType.find(:first)
  end

  def test02_find1
    item = ProjectType.find(1)
    assert item 
    assert item.id == 1
    assert item.name == 'project'
    assert item.path == item.name
  end

  def test03_find2
    item = ProjectType.find(2)
    assert item 
    assert item.id == 2
  end
  
  def test04_new
    item = ProjectType.new
    assert item 
    assert item.new_record?
  end

  def test05_update
    item = ProjectType.find(:first)
    assert item 
    assert item.save
  end

  def test06_hash_list_of_dashboard_options
    item = ProjectType.dashboard_list
    assert item 
    assert item.is_a?(Array)
  end
  

  def test09_not_valid
    item = ProjectType.new(:description=>'')
    assert item 
    assert !item.valid?
    assert item.errors[:name]
    assert item.errors[:description]
  end

  def test10_valid
    item = ProjectType.new
    item.name ="xxxx"
    item.description ='sfsfs '
    item.dashboard = 'projects'
    assert item.valid?
  end

  
   
end
