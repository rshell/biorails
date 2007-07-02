require File.dirname(__FILE__) + '/../test_helper'

class RoleTest < Test::Unit::TestCase
  fixtures :roles
  fixtures :role_permissions
  
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test001_permission
    item = RolePermission.find(:first)
    assert !item.nil?
  end
  
  def test002_permissions
     role =  Role.find(1)
     item = role.permissions
     assert item.size>1
  end
  
  def test003_subjects
     item = Role.subjects
     assert item.size>1
  end
  
  def test014_crud
    item = Role.new(:name=>'xxx',:description=>'xxxxx')
    assert item.save
    item2 = Role.find_by_name('xxx')
    assert item.id = item2.id
    item2.description = 'y'
    assert item2.save
    assert item.destroy
  end

  def test015_find    
    assert Role.find(1)
    assert Role.find_by_name('Public')
  end

  def test016_grant
    puts "test016"
    role = Role.find_by_name('Public')
    role.rebuild
    assert !role.allow?("study","show")
    assert role.grant("study","show")
  end 
  
    def test017_allow?
    puts "test017"
    assert_nil Role.find_by_name('test2')
    item = Role.new(:name=>'test2',:description=>'xxxxx')
    item.rebuild
    assert item.save    
    assert !item.allow?('study','show')
    item.grant('study','show')
    assert item.destroy
  end

  def test018_deny
    role = Role.find_by_name('Public')
    assert role.id==1
    assert role.grant('study','show')
    assert !role.deny('study','show')
  end


  

  
end
