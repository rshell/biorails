require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model UserRole
  ## Biorails::Dba.import_model User

  def assert_ok(object)
     assert_not_nil object, ' Object is missing'
     assert object.errors.empty? , " #{object.class}.#{object.id} has errors: "+object.errors.full_messages().join(',')
     assert object.valid?,         " #{object.class}.#{object.id} not valid: "+object.errors.full_messages().join(',')
     assert !object.new_record?,   " #{object.class}:#{object} not saved"
  end
  
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  
  def test001_create
     user = User.new
     user.name ="test"
     user.username ="test"
     user.set_password("xxx-xxx")
     user.fullname="test account"
     user.admin =false
     user.role = Role.find(:first)
     user.save
     assert_ok user
  end
  

  def test002_valid
     user = User.new
     assert !user.valid?
  end
    
  def test003_duplicate
     user = User.find_by_name('test2')
     user.destroy if user
     user = User.new(:name=>'test2')
     user.set_password "xxx-xxx"
     user.fullname="test account"
     user.admin =false
     user.role = Role.find(:first)
     user.login='ddddddddddddd'
     assert user.save, 'save first test2 user'
     assert_ok user
     user = User.new(:name=>'test2')
     user.set_password "xxx-xxx"
     user.fullname="test account"
     user.admin =false
     user.role = Role.find(:first)
     user.login='ddddddddddddd'
     assert !user.save,' should fail save test2 user duplicate '
  end
  
  
  def test004_create_project
     user = User.find(:first)
     project = user.create_project(:name=>"test-projectss",:summary=>'somthing')
     assert_ok project
     assert user.projects.detect{|i|i==project}, "project on my list"
  end
  
  
  def test005_check_access_control
     user = User.find_by_name('test5')
     user.destroy if user
     user = User.new(:name=>'test5')
     assert user.changable?
     user.set_password "xxx-xxx"
     user.fullname="test account"
     user.admin =false
     user.role = Role.find(:first)
     user.login='ddddddddddddd'
     assert user.save, 'save test5 user'
     
     assert user.changable?
     assert user.visible?
  end
  
  def test006_visible?
     user = User.new(:name=>'test6')
     assert user.new_record?, "should be a new record"
     assert user.changable?, "should be changable"
  end
  
  def test007_permission?
     user = User.new(:name=>'test7')
     role = Role.find(:first)
     user.role = role
     assert user.new_record?
     assert user.changable?
     assert user.role == role
  end
end
