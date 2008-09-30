require File.dirname(__FILE__) + '/../test_helper'

class ReportTest < Test::Unit::TestCase
  ## Biorails::Dba.import_model :user_roles
  ## Biorails::Dba.import_model :project_roles
  ## Biorails::Dba.import_model :users
  ## Biorails::Dba.import_model :projects
  ## Biorails::Dba.import_model :memberships
  ## Biorails::Dba.import_model :reports
  ## Biorails::Dba.import_model :report_columns
  
  # Replace this with your real tests.
  def setup
     @model = Report
  end
  
  def test_truth
    assert true
  end
  
  def test_find
     first = @model.find(:first)
     assert first.id
     assert first.name
  end
    
  def test_has_name
    first = @model.find(:first)
    assert first.name    
  end

   def test_valid
    first = @model.find(:first)
    assert first.valid?   
  end

  def test_update
    assert_ok first = @model.find(:first)
    assert first.save  
  end

  def test_to_s
    first = @model.find(:first)
    assert !first.to_s.nil?  
  end

  def test_to_json
    first = @model.find(:first)
    assert !first.to_json.nil?  
  end

  def test_to_xml
    first = @model.find(:first)
    assert !first.to_xml.nil?  
  end
  
  def test_has_description
    first = @model.find(:first)
    assert first.description    
  end
  

  def test_create
    report = Report.for_model(Membership)
    report.column("role.name")
    report.column("user.name")
    assert report.save
    data = report.run(:page => 1) 
    assert_not_nil data
  end

  def test_create
    report = Report.for_model(Membership)
    report.column("role.name")
    report.column("user.name")
    column = report.column("user.name")
    assert report.save
    data = report.run(:page => 1) 
    assert_not_nil data
  end

  def test_create_custom
    report = Report.for_model(Project)
    column1= report.column("name")
    column2= report.column("team.name")
    column3= report.column("assays.name")
    column1.customize(:sort_direction=>'asc')
    column2.customize(:sort_direction=>'desc')
    column2.filter=""
    assert !column1.has_many?
    assert !column2.has_many?
    assert column3.has_many?
    assert report.save
    data = report.run(:page => 1) 
    assert_not_nil data
    assert data.is_a?(Array)
    assert data.size>0
    assert column1.value(data[0])
    assert_equal 1,column1.size(data[0])
    assert column2.value(data[0])
    assert column3.value(data[0])
  end


  def test_refresh  
    first = Report.find(:first)
    assert first.refresh({:sort=>'id',:filter=>{:id=>'>1'}})   
    assert first.run(:page=>1)    
  end

   def test_contains_column
    reports = Report.contains_column("task_id")
    assert reports
    assert reports.all?{|report| report.columns.any?{|i|i.name=="task_id"}}
  end

  def test_decimal_places
    first = @model.find(:first)
    assert first.decimal_places    
  end
   
  def test_displayed_columns 
    first = @model.find(:first)
    assert first.displayed_columns   
  end

  def test_order
    report = @model.find(:first)
    assert report.refresh({:sort=>'id',:filter=>{:id=>'>1'}})   
    assert report.order
  end

  def test_run
    report = @model.find(:first)
    data = report.run(:page=>1)
    assert data
    assert data.is_a?(Array)
    assert data.size>0
    assert report.sizes(data[0])
  end

  def test_max_depth
    report = @model.find(:first)
    assert report.refresh({:sort=>'id',:filter=>{:id=>'>1'}})   
    assert report.max_depth
  end

  def test_conditions_greater
    report = @model.find(:first)
    assert report.refresh({:sort=>'id',:filter=>{:id=>'>1'}})   
    assert report.conditions
  end

  def test_conditions_equal
    report = @model.find(:first)
    assert report.refresh({:sort=>'id',:filter=>{:id=>'=1'}})   
    assert report.conditions
    assert report.run(:page => 1) 
  end

  def test_conditions_none
    report = @model.find(:first)
    assert report.refresh({:sort=>'id',:filter=>{:id=>'1'}})   
    assert report.conditions
    assert report.run(:page => 1) 
  end

  def test_conditions_in
    report = @model.find(:first)
    assert report.refresh({:sort=>'id', :filter=>{ :id=> 'in (1,2,3)'}})   
    assert report.conditions
    assert report.run(:page => 1) 
  end
  
  def test_conditions_like
    report = @model.find(:first)
    assert report.refresh({:sort=>'id',:filter=>{:id=>"like 1%"}})   
    assert report.conditions
    assert report.run(:page => 1) 
  end

  def test_conditions_less
    report = @model.find(:first)
    assert report.refresh({:sort=>'id',:filter=>{:id=>'<100'}})   
    assert report.conditions
  end


end
