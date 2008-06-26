require File.dirname(__FILE__) + '/../test_helper'

class AssayTest < Test::Unit::TestCase

  NEW_STUDY = {:name => 'Test Assay', :description => 'Dummy', :project_id=>1}
  REQ_ATTR_NAMES 			 = %w(name) # name of fields that must be present, e.g. %(name description)
  DUPLICATE_ATTR_NAMES = %w(name) # name of fields that cannot be a duplicate, e.g. %(name description)

  STUDY1_XML = ' <assay><id type="integer">3</id></assay>'
  STUDY2_XML = '<assay><name>ScreenXXX</name><description>xxx</description><project-id type="integer">1</project-id></assay>'
  STUDY3_XML = ' <assay><project-id type="integer">1</project-id><name>ScreenYYY</name><description>xxx</description></assay>'

  def setup
    # Retrieve ## Biorails::Dba.import_model via their name
    @first = Assay.find(1)
  end
  
  def test_should_find_protocol_by_name 
    assert_equal "Dose", @first.protocol("Protocol1").protocol_catagory
  end
  
  def test_should_find_experiment_by_name
    assert_equal "Experiment1",@first.experiment("Experiment1").name
  end
  
  def test_allowed_parameter_roles
    assert_equal 4,@first.allowed_roles.size
  end
  
  def test_return_parameters_for_assay_with_given_role
    assert_equal "Length", @first.parameters_for_role(2)[0].name
    assert_equal 4, @first.parameters_for_role(nil).size
  end
  
  def test_return_parameters_for_assay_with_given_datatype
    assert @first.parameters_for_data_type(2).any?{|i|i.name=="Count"}
  end
  
  def test_should_return_tasks_for_assay
    assert_equal 1, @first.tasks.size
    assert_equal 'Task1', @first.tasks[0].name
  end
  
  def test_should_return_protocols_in_given_stage
    assert_equal 2, @first.protocols_in_stage(nil).size
    stage=AssayStage.find(5)
    list =  @first.protocols_in_stage(stage)
    assert list
    assert list.is_a?(Array)
  end
  
  def test_should_return_queues_in_given_stage
    assert_equal 1, @first.queues_in_stage(nil).size
    stage=AssayStage.find(6)
    assert_equal 'ServiceQueue1', @first.queues_in_stage(stage)[0].name
  end 

  def test001_raw_validation
    assay = Assay.new
     # If Assay has validation, then use the following:
    assert !assay.valid?, "Assay should not be valid without initialisation parameters"
  end

  def test002_new
    assay = Assay.new(NEW_STUDY)
    assert assay.valid?, "Assay should be valid"
    NEW_STUDY.each do |attr_name|
      assert_equal NEW_STUDY[attr_name], assay.attributes[attr_name], "Assay.@#{attr_name.to_s} incorrect"
    end
  end


  def test007_to_xml
      assay = Assay.find(:first)
     assert_not_nil assay
      xml = assay.to_xml()
      assert_not_nil xml
  end
    
    
  def test008_from_xml
    assay = Assay.from_xml(nil)
    assert false,"failed to throw"
  rescue
    assert true      
  end

  #    def test009_from_xml_with_lookup
  #      assay = Assay.from_xml(STUDY1_XML)
  #      assert_not_nil assay
  #      assert assay.id==3
  #      assert assay.valid?, "record not valid #{assay.errors.full_messages().join('\n')}"
  #    end
    
  def test010_from_xml_with_attibute
    assay = Assay.from_xml(STUDY2_XML,:create=>[:assay])
    assert_not_nil assay
    assert assay.valid?, "record not valid #{assay.errors.full_messages().join('\n')}"
  end

  def test011_from_xml_with_reference
    assay = Assay.from_xml(STUDY3_XML,:create=>[:assay])
    assert_not_nil assay
    assert assay.valid?, "record not valid #{assay.errors.full_messages().join('\n')}"
  end


  def test012_xml_assay_file
    file = File.open(File.join(RAILS_ROOT,'test','fixtures','files','Assay1.xml'))
    assay = Assay.from_xml(file, :override=>{:name=>'xx-import',:project_id=>2},
                                     :create=>[:assay ,:assay_protocol,:assay_process,:assay_parameter,:process,
                                              :protocol_version,:parameter_context,:parameter],
                                     :include=>[:parameters,:protocols,:queues]        )
    assert_not_nil assay
    assert_ok assay
    assert_equal 'xx-import', assay.name
    assert_equal 4,assay.parameters.size, " Wrong number of parameters #{assay.parameters.size}"
    assert_equal 1, assay.queues.size, " wrong number of services #{assay.queues.size}"
    assert_equal 2, assay.protocols.size, " wrong number of protocols #{assay.protocols.size}"
  end
    
    
  def test013_is_setup
    assay = Assay.find(:first)
    assert assay.is_setup?
    assay = Assay.new
    assert !assay.is_setup?
  end
    
  def test014_has_queues
    assay = Assay.find(:first)
    assert assay.has_queues?
    assay = Assay.new
    assert !assay.has_queues?
  end
    
  def test015_has_protocols?
    assay = AssayProtocol.find(:first).assay
    assert assay.has_protocols?
    assay = Assay.new
    assert !assay.has_protocols?
  end
    
  def test016_has_parameters?
    assay = AssayQueue.find(:first).assay
    assert assay.has_parameters?
    assay = Assay.new
    assert !assay.has_parameters?
  end
    
  def test017_has_parameter_of_data_type?
    assay = AssayParameter.find(:first,:conditions=>"data_type_id=5").assay
    list = assay.parameters_for_data_type(5)
    assert list
    assert list.size>0
    assert assay.has_parameter_of_data_type?(5)

  end
    
  def test018_stages
    assay = Assay.find(:first)
    assert assay.stages
  end
    
  def test_parameter_roles
    assay = Assay.find(:first)
    assert assay.parameter_roles
  end

  def test_parameter_roles_with_type
    assay = Assay.find(ParameterType.find(:first))
    assert assay.parameter_roles
  end
    
  def test020_parameter_types
    assay = Assay.find(:first)
    assert assay.parameter_types
  end
    
  def test021_parameter_grid
    assay = Assay.find(:first)
    assert assay.parameter_grid
  end
    
  def test022_parameter_grid
    assay = Assay.find(:first)
    assert assay.to_xml
  end

  def test023_parameter_grid
    assay = Assay.find(:first)
    assert assay.to_html
  end
    
  def test_assay_path
    assay= Assay.find_by_name('Assay1')
    assert_equal 'Project X:Assay1', assay.path
    assert_equal 'Assay1',assay.path('assay')
  end
    
  def test_process_flows_with_string
    assay=Assay.find_by_name('Assay1')
    list = assay.process_flows('flow1')
    assert list
    assert list.is_a?(Array)
  end
  
  def test_process_flows_with_nil
    assay=Assay.find_by_name('Assay1')
    list = assay.process_flows(nil)
    assert list
    assert list.is_a?(Array)
  end
  
  def test_process_instances_string
    assay=Assay.find_by_name('Assay1')
    list = assay.process_flows('flow1')
    assert list
    assert list.is_a?(Array)
  end
  
  def test_process_instances_nil
    assay=Assay.find_by_name('Assay1')
    list = assay.process_flows(nil)
    assert list
    assert list.is_a?(Array)
  end

    def test_parameter_type_by_role
    assay = Assay.find(:first)
    role = ParameterRole.find(:first)
    list =  assay.parameter_types(role)
    assert list
    assert list.is_a?(Array)
  end

    def test_parameter_type_by_role_id
    assay = Assay.find(:first)
    role = ParameterRole.find(:first)
    list =  assay.parameter_types(role.id)
    assert list
    assert list.is_a?(Array)
  end
    
  def test_parameter_type_no_role
    assay = Assay.find(:first)
    list =  assay.parameter_types
    assert list
    assert list.is_a?(Array)
  end
    
  def test_path
    assay = Assay.find(:first)
    assert assay.path
    assert assay.path(:world)
    assert assay.path(:assay)
    assert assay.path(:xxxxx)
  end
    
  def test_published
    assay=Assay.find_by_name('Assay1')
    assert assay.published?
  end
    
  def test_export_import
    assay=Assay.find_by_name('Assay1')
    num = assay.parameters.size
    assert num>0,"Need some parameters for a valid test"    
    output = assay.export_parameters
    assert output
    assert output.to_s
    new_assay = Assay.new(NEW_STUDY)
    assert new_assay.save
    warnings = new_assay.import_parameters(output)
    assert_equal warnings.size,0
    assert_equal assay.parameters.size,new_assay.parameters.size
  end
  
  
  def test_import_parameters_with_reference_id
     file = ActionController::TestUploadedFile.new(Test::Unit::TestCase.fixture_path+
         '/files/test-parameters.csv', 'text/csv') 
    new_assay = Assay.new(NEW_STUDY)
    assert new_assay.save
    warnings = new_assay.import_parameters(file)
    assert_equal 0,warnings.size,warnings.join('\n')
    assert_equal 4,new_assay.parameters.size
    assert_ok new_assay.parameters.find_by_name('Compound')
    assert_ok new_assay.parameters.find_by_name('Concentration')
    assert_ok new_assay.parameters.find_by_name('Count')
    assert_ok new_assay.parameters.find_by_name('Length')
    assert  'mM',new_assay.parameters.find_by_name('Concentration').display_unit
    assert 'in',new_assay.parameters.find_by_name('Length').display_unit
  end

  def test_import_parameters_without_reference_id_and_with_errors
     file = ActionController::TestUploadedFile.new(Test::Unit::TestCase.fixture_path+
         '/files/test2-parameters.csv', 'text/csv') 
    new_assay = Assay.new(NEW_STUDY)
    assert new_assay.save
    warnings = new_assay.import_parameters(file,false,true)
    assert_equal 2,warnings.size,warnings.join('\n')
    assert_equal 2,new_assay.parameters.size    
    assert new_assay.parameters.any?{|p|p.name == 'Compound' and p.role.name='subject' and p.type.name='Compound' and p.data_type.name='dictionary'}
    assert new_assay.parameters.any?{|p|p.name == 'Length' and p.role.name ='moose'}
    assert_ok new_assay.parameters.find_by_name('Compound')
    assert_ok new_assay.parameters.find_by_name('Length')
  end

  def test_import_parameters_twice
     file = ActionController::TestUploadedFile.new(Test::Unit::TestCase.fixture_path+
         '/files/test-parameters.csv', 'text/csv') 
    new_assay = Assay.new(NEW_STUDY)
    assert new_assay.save
    warnings = new_assay.import_parameters(file)
    assert_equal 0,warnings.size
    assert_equal 4,new_assay.parameters.size
    warnings = new_assay.import_parameters(file)
    assert_equal 4,new_assay.parameters.size
    assert_equal 0, warnings.size
  end

end

