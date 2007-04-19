require File.dirname(__FILE__) + '/../test_helper'

class RoleTest < Test::Unit::TestCase
  fixtures :roles
  fixtures :users
  fixtures :projects
  fixtures :memberships
  fixtures :reports
  fixtures :report_columns
  
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test001_find
    item = Report.find(:first)
    assert !item.nil?
  end  

  def test001_create
    report = Report.for_model(Membership)
    report.column("role.name")
    report.column("user.name")
    assert report.save
    data = report.run 
    assert_not_nil data
  end
end
