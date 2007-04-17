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
  
  def test003_possible_subjects
     item = Role.possible_subjects
     assert item.size>1
  end

  def test004_get_controllers
     item = Role.controllers
     assert item.size>1
  end

  def test005_reload
     item = Role.reload
     assert item.size>1
  end
  
  def test006_possible_actions
     assert Role.is_checked?('study','show')
  end
  
  def test007_actions
     item = Role.methods(FinderController)
     assert item.size>0
  end
  
  def test008_possible_actions
    assert_not_nil Role.possible_actions('study')   # study
    assert_not_nil Role.possible_actions('task')     # execute
    assert_not_nil Role.possible_actions('project')  # projects
    assert_not_nil Role.possible_actions('user')     # admin
    assert_not_nil Role.possible_actions('inventory') # inventory
  end


  def test010_possible
     assert Role.is_checked?('study','show')
     assert !Role.is_checked?('studies','xxxxx')
  end

  def test011_invalid
    item = Role.new
    assert !item.valid?
    assert item.errors.invalid?(:name)
    assert item.errors.invalid?(:description)
  end

  def test012_valid
    item = Role.new
    item.name='xyxy'
    item.description ='dfdfdf'
    assert item.valid?
    assert !item.errors.invalid?(:name)
    assert !item.errors.invalid?(:description)
  end

  def test013_duplicate
    role = Role.find(:first)
    item = Role.new(:name=> role.name, :description=>'xxxxx' )
    assert !item.save
    
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
    assert Role.is_checked?("study","show")
    assert !role.allow?("study","show")
    assert role.grant("study","show")
    assert_not_nil role.cache["study"], "check subject in cache"
    puts   " subjects= #{role.cache.keys.join(',')}"
    puts   " actions=  #{role.cache["study"].keys.join(',')}"
    assert role.cache["study"]["show"]==true, "check action in cache"
    assert role.allow?("study","show"), "check now passes allow?"  
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
    assert role.deny('study','show')
  end


  

  
end
