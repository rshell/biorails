require File.dirname(__FILE__) + '/../test_helper'

class TeamTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_find
    item = Team.find(:first)
    assert_ok item
  end 

  def test_news
    item = Team.find(:first)
    assert item.news
  end 

  def test_owners
    item = Team.find(:first)
    assert item.owners
  end 

  def test_memberships
    item = Team.find(1)
    list = item.memberships
    assert list
    assert list.is_a?(Array)
    assert list.size>0
    assert list[0].is_a?(Membership)
  end 

  def test_users
    item = Team.find(1)
    list = item.users
    assert list
    assert list.is_a?(Array)
    assert list.size>0
    assert list[0].is_a?(User)
  end 

  def test_users
    item = Team.find(1)
    list = item.users
    assert list
    assert list.is_a?(Array)
    assert list.size>0
    assert list[0].is_a?(User)
  end 

  def test_projects
    item = Team.find(1)
    list = item.projects
    assert list
    assert list.is_a?(Array)
    assert list.size>0
    assert list[0].is_a?(Project)
  end 
  
  def test_non_members
    item = Team.find(1)
    list = item.non_members
    assert list
    assert list.is_a?(Array)
    assert_equal 0, list.size
  end 

  def test_experiments
    item = Team.find(1)
    list = item.experiments
    assert list
    assert list.is_a?(Array)
  end 

  def test_owners
    item = Team.find(:first)
    assert item.owners
  end 

  def test_owners
    item = Team.find(:first)
    assert item.owners
  end 

  def test_is_use
    item = Team.find(1)
    assert item.in_use?
  end 

  def test_update
    item = Team.find(:first)
    item.description='sfsfsfsfs'
    item.save
    assert_ok item
  end 
  
end
