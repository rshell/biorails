require File.dirname(__FILE__) + '/../test_helper'

class AccessControlListTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def setup
     @team = Team.find(:first)
     @project = Project.current = Project.find(:first)
     @user = User.current = User.find(3)
     @role = ProjectRole.find(:first)
     @acl = AccessControlList.find(:first)
  end

  def test_setup
    assert_ok @team
    assert_ok @project
    assert_ok @user
    assert_ok @role
    assert_ok @acl 
  end
  
  def test_has_rules
    assert @acl.rules
  end

  def test_has_usages
    assert @acl.usages
  end

  def test_has_team
    assert @acl.team
  end

  def test_has_used?
    @used_acl = ProjectFolder.find(:first).access_control_list
    assert @used_acl.used?
  end

  def test_to_s
    assert @acl.to_s
  end

  def test_create_list
    list = AccessControlList.create
    assert_ok list
  end

  def test_create_grant_user
    assert_ok list = AccessControlList.create
    assert_ok rule = list.grant(@user,@role)
    assert @user,rule.owner
    assert @role,rule.role
    assert list.has?(@user,@role)
  end

  def test_create_grant_twice_doesnt_change_list
    assert_ok list = AccessControlList.create
    assert_ok rule = list.grant(@user,@role)
    n = list.rules.size
    list.grant(@user,@role)
    assert_equal n,list.rules.size
  end

  def test_check_hash_identical_list_match
    assert_ok list1 = AccessControlList.from_team(@team)
    assert_ok list2 = list1.copy
    assert_equal list1.calculate_checksum,list2.calculate_checksum
  end

  def test_check_hash_difference_lists_not_same
    assert_ok list1 = AccessControlList.from_team(@team)
    assert_ok list2 = AccessControlList.create
    assert_not_equal list1.content_hash, list2.content_hash
  end

  def test_create_grant_team
    assert_ok list = AccessControlList.create
    assert_ok rule = list.grant(@team,@role)
    assert @user,rule.owner
    assert @role,rule.role
    assert list.has_access?(@team)
    assert list.has?(@team,@role)
  end

  def test_create_list_from_team
    assert list = AccessControlList.from_team(@team)
    assert_ok list
    assert list.has?(User.current,ProjectRole.owner)," missing user "
    assert list.has?(@team,ProjectRole.member)," missing team "
  end

  def test_create_list_copy
    assert list = AccessControlList.from_team(@team)
    assert_ok list
    assert list2 = list.copy
    assert_ok list2
    assert_equal list2.rules.size, list.rules.size
  end

end
