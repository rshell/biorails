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
    assert first.limit
    assert first.start
    assert first.page
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


  def test_add_ext_filter
    report = @model.find(:first)
    data = report.add_ext_filter({:start=>10,:limit=>100,:sort=>[],:fields=>"[1]",:query=>'x'})
    assert_equal 10, report.start
    assert_equal 100, report.limit
  end

  def test_ext_default_filter
    report = @model.find(:first)
    data = report.ext_default_filter
  end

  def test_ext_non_filterable
    report = @model.find(:first)
    data = report.ext_non_filterable
    assert data
  end

  def test_ext_advanced_filters
    report = @model.find(:first)
    data = report.ext_advanced_filters
    assert data
  end

  def test_ext_columns_json
    report = @model.find(:first)
    data = report. ext_columns_json
    assert data
  end

  def test_ext_model_json
    report = @model.find(:first)
    data = report.ext_model_json
    assert data
  end

  def test_to_ext
    report = @model.find(:first)
    data = report.to_ext
    assert data
  end

  def test_find_all_using_model
    data = Report.find_all_using_model(Task)
    assert data
  end

  def test_add_ext_filter_null
    report = @model.find(:first)
    data = report.add_ext_filter({})
    assert_equal 0, report.start
    assert_equal 15, report.limit
  end

  def test_create_internal_report_default_then_customize
    report = SystemReport.internal_report("ParameterProtocols",Parameter)
    report.column('assay_parameter_id').is_visible = false
    report.column('process.name').customize(:is_sortable=>true,:is_visiable=>true)
    report.column('assay_parameter_id').filter = "xx"
    report.save
    assert_ok report
  end

  def test_create_internal_report_with_block
    report1 = SystemReport.internal_report("ParameterProtocols",Parameter) do |report|
      report.column('assay_parameter_id').is_visible = false
      report.column('process.name').customize(:is_sortable=>true,:is_visiable=>true)
      report.column('assay_parameter_id').filter = "xx"
    end
    assert_ok report1
  end

  def test_create_project_report_default_then_customize
    report = ProjectReport.project_report("ParameterProtocols",Parameter)
    report.column('assay_parameter_id').is_visible = false
    report.column('process.name').customize(:is_sortable=>true,:is_visiable=>true)
    report.column('assay_parameter_id').filter = "xx"
    report.save
    assert_ok report
  end

  def test_create_project_report_with_block
    report2 = ProjectReport.project_report("ParameterProtocols",Parameter) do |report|
      report.column('assay_parameter_id').is_visible = false
      report.column('process.name').customize(:is_sortable=>true,:is_visiable=>true)
      report.column('assay_parameter_id').filter = "xx"
    end
    assert_ok report2
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

  def test_domain_list
    assert report = Biorails::SystemReportLibrary.domains_list("dddddd")
    data = report.run
    assert data
    assert data.size>1
    assert data[0].is_a?(Project)
  end

end
