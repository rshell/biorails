require File.dirname(__FILE__) + '/../test_helper'

class RoleTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :user_roles
  ## Biorails::Dba.import_model :project_roles
  ## Biorails::Dba.import_model :users
  ## Biorails::Dba.import_model :projects
  ## Biorails::Dba.import_model :memberships
  ## Biorails::Dba.import_model :reports
  ## Biorails::Dba.import_model :report_columns
  
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
