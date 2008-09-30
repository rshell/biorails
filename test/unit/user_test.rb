require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'
class UserTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model UserRole
  ## Biorails::Dba.import_model User

  
  def login_failure_should_increase_failure_count
    user=User.find(3)
    user.register_login_failure
    assert 1, user.failure_count
  end
  
  def test_register_login_failure_for_user
    assert !User.register_login_failure('fred')
    u=User.find_by_name('guest')
    failed=u.login_failures
    User.register_login_failure('guest')
    assert_equal failed+1, User.find_by_name('guest').login_failures
    Notification.expects(:deliver_excessive_login_failures).with(u)
    until User.find_by_name('guest').login_failures > SystemSetting.get("max_login_attempts").value do
      User.register_login_failure('guest')
    end
  end
  
  def test_login
    assert_nil User.login('fred','any')
    assert_nil User.login('guest', 'any')
    assert_equal 'Robert Shell', User.login('rshell', 'y90125').name
  end
  
  def test_public_key
#
#    @TODO work out why key has changed    
#    user=User.find(3)
#    assert_equal "-----BEGIN RSA PUBLIC KEY-----\nMIICCgKCAgEAsICiz9FXzxw5IPYv+46BNitAkrnhf0Uc+erawH7mDmluvSmiPQwg\na2vWS7DlG6hLGkdLBbycRK+7fn0ULazIoVjK+n/4oEyLL58CxpgDt5F2sVLzwMSk\nMvRb6MPeQfmH2IwH8a6rE7csP4TA8cHxkx2wYRy105jytr9hJn/cgmwx1DUzyoie\nDR7fxSXbJo0pk6NiYPDiT73CLTXjiP/ERrmokY28uEEzmsTyoIqB0cuf4KPvLUhl\nU/L8ppPpF5pPuLnmdTJbBZz6yCD/3EqkMHe2cDWIXjMuHXIT56GuJjCwrDNHnz5U\n6zN3z+0JZHtPUFWu23IkTJ7kLphjKpHDUFSca/1vC3swh2BFNn0t8sW4Y/uXjv0a\nv3ENf2WgcvLKgJXHnGo3ckCyujMkgf0HD4kqGdQzUMhOghrS7PuGTqhaurYovenU\nRy7aPTf9XpUg58G+WORuKNoMaQhi2jf6VU+0Bn/xSMkmJdZMcYyXs/84yEjggmoi\n7B6lCx0yXSp0HNQy/N4aHccAy6JAUlr2QkYAC+VqWnySdq6y5htJwl/7ZKZy40r7\nSd+x/3bOFh0jOgv+4mzVLhQoJ/FofeuVgGk1EHmqGusJiWK8broBBl6k46oteTjv\n63C8GIZTnrQJh/zxGhAYlRDGJj/bdW+Igu3gwi7S9pt+HIVCTd4p+iUCAwEAAQ==\n-----END RSA PUBLIC KEY-----\n", user.public_key.to_s
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
     assert_not_nil user.private_key
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
     project = user.create_project(:name=>"test-projects",:description=>'somthing')
     project.save
     assert_ok project
  end
  
  
  def test005_check_access_control
     user = User.find_by_name('test5')
     user.destroy if user
     user = User.new(:name=>'test5')
     user.set_password "xxx-xxx"
     user.fullname="test account"
     user.admin =false
     user.role = Role.find(:first)
     user.login='ddddddddddddd'
     assert user.save, 'save test5 user'
  end
  
  def test006_visible?
     user = User.new(:name=>'test6')
     assert user.new_record?, "should be a new record"
  end
  
  def test007_permission?
     user = User.new(:name=>'test7')
     role = Role.find(:first)
     user.role = role
     assert user.new_record?
     assert user.role == role
  end

  def test008_news
     user = User.find(3)
     assert user.news
  end   

  def test009_style
     user = User.find(3)
     assert user.style
  end   

  def test010_projects 
     user = User.find(3)
     assert user.projects 
     user = User.find(1)
     assert user.projects 
  end   

  def test011_project
     user = User.find(3)
     assert user.project(1)
     user = User.find(1)
     assert user.project(1)
  end   

  def test012_news
     user = User.find(1)
     assert user.news
     user = User.find(3)
     assert user.news
  end   

  def test015_assay
     User.current = User.find(3)
     assert Assay.find_visible(:all)

  end   

  def test016_experiment
     assert User.current = User.find(3)
     assert Experiment.find_visible(:all)
  end
  

  def test017_protocol
     User.current =User.find(3)
     assert AssayProtocol.find_visible(:first)
     User.current = User.find(1)
     assert AssayProtocol.find_visible(:all)
  end   

  def test018_task
     User.current = User.find(3)
     assert Task.find_visible(:first)
     User.current = User.find(1)
     assert Task.find_visible(:all)
  end   
  
  def test019_lastest_for_rshell
     user = User.find(3)
     assert user.latest(Team)
     assert user.latest(Project)
     assert user.latest(Request)
     assert user.latest(RequestService)
     assert user.latest(Assay)
     assert user.latest(AssayParameter)
     assert user.latest(AssayQueue)
     assert user.latest(AssayProtocol)
     assert user.latest(Experiment)
     assert user.latest(Task)
  end   

  def test020_lastest_for_guest
     user = User.find(1)
     assert user.latest(Team)
     assert user.latest(Project)
     assert user.latest(Request)
     assert user.latest(RequestService)
     assert user.latest(Assay)
     assert user.latest(AssayParameter)
     assert user.latest(AssayQueue)
     assert user.latest(AssayProtocol)
     assert user.latest(Experiment)
     assert user.latest(Task)
  end   
  
  def test022_to_xml
     user = User.find(3)
     xml = user.to_xml
     assert xml     
  end

  def test023_create_team
     user = User.find(3)
     team = user.create_team(:name=>'test025',:description=>'test025')
     assert_ok team
     assert team.valid?
     assert team.memberships 
     assert team.access_control_list
     assert_equal 1, team.memberships.size    
  end
  
  def test024_et_password
     user = User.find(1)
     user.set_password('old_password')    
  end
  
    def test025_reset_password
     user = User.find(1)
     user.set_password('old_password')
     assert user.save
     assert  user.password?('old_password')
     assert !user.password?('new_password')
     user.clear_login_failures

     assert !user.reset_password('xxxxxxx','new_password','new_password')      
     assert user.reset_password('old_password','new_password','new_password')
     assert !user.password?('old_password')
     assert user.password?('new_password')
  end

  def test026_login
     user = User.find(1)
     user.set_password('old_password')
     assert user.reset_password('old_password','new_password','new_password')
     assert user.save
     user.reload
     assert x = User.login(user.login,'new_password')
     assert_equal x,user
  end

  def test027_login_failed
     user = User.find(1)
     user.set_password('old_password')
     assert user.save
     assert !User.login(user.login,'new_password')
  end
      
  
   def test029_register_login_failure
     user = User.find(3)
     user.clear_login_failures
     User.register_login_failure('rshell')
     User.register_login_failure('rshell')
     User.register_login_failure('rshell')
     User.register_login_failure('rshell')
     User.register_login_failure('rshell')    
     user = User.find(3)
     assert user.login_failures==5
   end
   
   def test_create_project
     user=User.find(3)
     proj=user.create_project(:name=>'any')
     assert_equal 'any', proj.name
   end
       
    def test_user_enabled
      user=User.find(3)
      assert user.enabled?
      assert_equal 'Administrator', user.style
      user.admin=false
      assert_equal 'Normal', user.style
      user.deleted_at=Time.now
      assert user.disabled?
      assert_equal 'Disabled', user.style
      assert !user.enabled?      
    end
   
    def test_create_user
      user = User.create_user('xxxxx','xxxxx')
      assert_ok user
      assert_equal 'xxxxx',user.login
    end
   
 
    
end
