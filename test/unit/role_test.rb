require File.dirname(__FILE__) + '/../test_helper'

class RoleTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :user_roles
  ## Biorails::Dba.import_model :project_roles
  ## Biorails::Dba.import_model :users
  ## Biorails::Dba.import_model :permissions
  ## Biorails::Dba.import_model :role_permissions
  
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
    assert Permission.is_checked?("assays","show")

    role = Role.new(:name=>'test016',:description=>'test016')
    role.save
    role.rebuild
    assert !role.allow?("assays","show")
    role.grant("assays","show")
    assert role.allow?("assays","show")
  end 
  
    def test017_allow?
    assert Permission.is_checked?("assays","show")

    item = Role.new(:name=>'test017',:description=>'test017')
    item.save
    item.rebuild
    assert item.save    
    assert !item.allow?('assays','show')
    assert item.grant('assays','show')
    assert item.allow?('assays','show')
    assert item.destroy
  end

  def test018_deny
    assert Permission.is_checked?("assays","show")

    role = Role.new(:name=>'test018',:description=>'test018')
    role.save
    assert role.grant('assays','show')
    assert role.allow?('assays','show')
    assert role.deny('assays','show')
    assert !role.allow?('assays','show')
    assert !role.deny('studsgdgdsgsdies','shodgdsgdsgdw')
  end

  def test019_reset

    changes = {
               "catalogue"=>{"list"=>"true", "*"=>"true"}, 
               "audit"=>{"show"=>"true", "*"=>"true"}
               } 
               
    role = Role.new(:name=>'test019',:description=>'test019')
    role.save
    role.reset_rights(changes)
    assert role.allow?('audit','show')
    assert role.allow?('catalogue','list')
    assert role.allow?('audit','*')
    assert !role.allow?('assay','list')
  end  

  
  def test20_subjects
    role = Role.find(:first)
    assert role.subjects    
    assert role.subjects.is_a?(Array)    
  end
 
  def test20_actions
    role = Role.find(:first)
    assert role.actions('project')    
  end
 

  def test21_permission?
    role = Role.find(:first)
    for subject in role.subjects
      role.permission?(User.find(3),subject,'show')
    end
  end

  def test022_grant_all
    assert Permission.is_checked?("assays","show")

    role = Role.new(:name=>'test023',:description=>'test023')
    role.save
    role.rebuild
    assert !role.allow?("assays","show")
    role.grant_all("assays")
    assert role.allow?("assays","show")
  end 

  def test023_deny_all
    assert Permission.is_checked?("assays","show")
    role = Role.new(:name=>'test023',:description=>'test023')
    role.save
    role.rebuild
    assert !role.allow?("assays","show")
    role.grant_all("assays")
    assert role.allow?("assays","show")
    role.deny_all("assays")
    assert !role.allow?("assays","show")
  end 
  
  def test024_project_role_subjects
    assert ProjectRole.subjects
  end
  
  def test025_project_role_owner
    assert ProjectRole.owner
  end
  
  def test026_project_role_member
    assert ProjectRole.member
  end

  def test027_user_role_subjects
    assert UserRole.subjects
  end
  
end
