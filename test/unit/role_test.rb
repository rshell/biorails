require File.dirname(__FILE__) + '/../test_helper'

class RoleTest < Test::Unit::TestCase
  fixtures :roles
  fixtures :role_permissions
  
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_permission
    item = RolePermission.find(:first)
    assert !item.nil?
  end
  
  def test_permissions
     role =  Role.find(1)
     item = role.permissions
     assert item.size>1
  end
  
  def test_get_models
     item = Role.models
     assert item.size>1
  end

  def test_get_controllers
     item = Role.controllers
     assert item.size>1
  end

  def test_get_models
     item = Role.models
     assert item.size>1
  end
  
  def test_all_actions
     item = Role.all_methods
     assert item.size>1
  end
  
  def test_actions
     item = Role.methods(FinderController)
     assert item.size>0
  end
  
  def test_controller
    assert_not_nil Role.controller('studies')   # study
    assert_not_nil Role.controller('tasks')     # execute
    assert_not_nil Role.controller('projects')  # projects
    assert_not_nil Role.controller('users')     # admin
    assert_not_nil Role.controller('compounds') # inventory
  end


  def test_possible
     assert_not_nil Role.possible('studies',:show)
     assert_not_nil Role.possible('studies','show')
     assert_nil Role.possible('studies',:moose)
  end

  def test_invalid
    item = Role.new
    assert !item.valid?
    assert item.errors.invalid?(:name)
    assert item.errors.invalid?(:description)
  end

  def test_valid
    item = Role.new
    item.name='xyxy'
    item.description ='dfdfdf'
    assert item.valid?
    assert !item.errors.invalid?(:name)
    assert !item.errors.invalid?(:description)
  end

  def test_duplicate
    item = Role.new(:name=> roles(:roles_public).name,
                    :description=>'xxxxx' )
    assert !item.save
    
  end
  
  def test_crud
    item = Role.new(:name=>'xxx',:description=>'xxxxx')
    assert item.save
    item2 = Role.find_by_name('xxx')
    assert item.id = item2.id
    item2.description = 'y'
    assert item2.save
    assert item.destroy
  end

  def test_find    
    assert Role.find(1)
    assert Role.find_by_name('Public')
  end

  def test_grant
    role = Role.find_by_name('Public')
    role.grant("test","show")
    assert role.allow?("test","show")    
    assert role.permissions.detect{ |item| item.subject =='test' and item.action=='show'}
    assert role.cache['test']['show']
  end 
  
    def test_allow?
    item = Role.new(:name=>'test1',:description=>'xxxxx')
    assert item.save    
    assert !item.allow?('role','show')
    item.grant('role','show')
  end

  def test_deny
    role = Role.find_by_name('Public')
    assert role.id==1

    assert role.deny('role','show')
    assert !role.allow?("test","show")    
    assert !role.permissions.detect{ |item| item.subject =='test' and item.action=='show'}
  end


  

  
end
