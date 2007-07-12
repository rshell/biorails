require File.dirname(__FILE__) + '/../test_helper'

class StudyTest < Test::Unit::TestCase
  fixtures :users
  fixtures :projects
  fixtures :memberships
  fixtures :parameter_types
  fixtures :parameter_roles
  fixtures :data_elements
  fixtures :data_types
  fixtures :data_formats
  
  fixtures :studies
  fixtures :study_protocols
  fixtures :study_parameters
  fixtures :protocol_versions
  fixtures :parameter_contexts
  fixtures :parameters
  fixtures :study_queues

	NEW_STUDY = {:name => 'Test Study', :description => 'Dummy', :project_id=>1}
	REQ_ATTR_NAMES 			 = %w(name description) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w(name) # name of fields that cannot be a duplicate, e.g. %(name description)

     STUDY1_XML = ' <study><id type="integer">3</id></study>'
     STUDY2_XML = '<study><name>ScreenXXX</name><description>xxx</description><project-id type="integer">1</project-id></study>'
     STUDY3_XML = ' <study><project-id type="integer">1</project-id><name>ScreenYYY</name><description>xxx</description></study>'

  def setup
    # Retrieve fixtures via their name
    # @first = studies(:first)
  end

  def test001_raw_validation
    study = Study.new
    if REQ_ATTR_NAMES.blank?
      assert study.valid?, "Study should be valid without initialisation parameters"
    else
      # If Study has validation, then use the following:
      assert !study.valid?, "Study should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert study.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test002_new
    study = Study.new(NEW_STUDY)
    assert study.valid?, "Study should be valid"
   	NEW_STUDY.each do |attr_name|
      assert_equal NEW_STUDY[attr_name], study.attributes[attr_name], "Study.@#{attr_name.to_s} incorrect"
    end
 	end

	def test003_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_study = NEW_STUDY.clone
			tmp_study.delete attr_name.to_sym
			study = Study.new(tmp_study)
			assert !study.valid?, "Study should be invalid, as @#{attr_name} is invalid"
    	assert study.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

#    def test007_to_xml
#      study = Study.find(:first)
#      assert_not_nil study
#      xml = study.to_xml()
#      assert_not_nil xml
#    end
    
    
    def test008_from_xml
      study = Study.from_xml(nil)
      assert false,"failed to throw"
    rescue
       assert true      
    end

#    def test009_from_xml_with_lookup
#      study = Study.from_xml(STUDY1_XML)
#      assert_not_nil study
#      assert study.id==3
#      assert study.valid?, "record not valid #{study.errors.full_messages().join('\n')}"
#    end
    
    def test010_from_xml_with_attibute
     study = Study.from_xml(STUDY2_XML,:create=>[:study])
      assert_not_nil study
      assert study.valid?, "record not valid #{study.errors.full_messages().join('\n')}"
    end

    def test011_from_xml_with_reference
     study = Study.from_xml(STUDY3_XML,:create=>[:study])
      assert_not_nil study
      assert study.valid?, "record not valid #{study.errors.full_messages().join('\n')}"
    end


#    def test012_xml_study_file
#      file = File.new File.dirname(__FILE__) + '/../fixtures/files/study.xml'
#      assert_not_nil file
#      study = Study.from_xml(file, :create=>[:study ,:study_protocol,:study_parameter,:process,
#                                            :protocol_version,:parameter_context,:parameter],
#                                   :include=>[:parameters,:protocols,:queues]         
#      )
#      assert_not_nil study
#      assert study.valid?, "record not valid"
#
#      assert study.parameters.size ==18, " Wrong number of parameters #{study.parameters.size}"
#      assert study.parameters[0].name == 'Counts'
#      assert study.parameters[0].id != 82
#
#      assert study.queues.size ==3, " wrong number of services #{study.queues.size}"
#      assert study.queues[0].name == 'Develop Assay'
#      assert study.queues[0].id != 24
# 
#      assert study.protocols.size ==5, " wrong number of protocols #{study.protocols.size}"
#      assert study.protocols[0].name == 'Hit Identification'
#      assert study.protocols[0].id != 25
#      
#    end
    
    
    
end

