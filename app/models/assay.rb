# == Schema Information
# Schema version: 359
#
# Table name: assays
#
#  id                 :integer(4)      not null, primary key
#  name               :string(128)     default(""), not null
#  description        :string(1024)    default(""), not null
#  category_id        :integer(4)
#  research_area      :string(255)
#  purpose            :string(255)
#  started_at         :datetime
#  ended_at           :datetime
#  expected_at        :datetime
#  team_id            :integer(4)      not null
#  project_id         :integer(4)      not null
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#  project_element_id :integer(4)
#

# == Description
# An assay definition provides the organisation for capturing structured data within experiments. 
# Each assay definition has its own name space built 
# from the catalogue by assigning parameter types, with roles as assay parameters.  
# Once the parameters are assigned, services can be registered against which users 
# can make requests.  These services are implemented as service queue parameters. 
# These queue parameters can be built into the assays processes as a way of automatically 
# returning data against items submitted in a request to a service. 
#
# === Structure
# Once the parameters are assigned, Process processes can be built. These processes are implemented 
# as data entry sheets within tasks . The idea is that there are likely to be a collection of 
# processes used to run an experiment.  Some of these processes may be used to set up the experiment, 
# others to capture data and others to analyse the data within an experiment.  
# The processes therefore map to the steps that must be executed in order to run an experiment.  
# These steps can be formalised in a work-flow recipe, where the processes can be added with default 
# owners and starting points from the start of the experiment.
#  
# === Content
# An assay definition will automatically have a folder and show up on the project tree.  
# Documentation for running the assays (executing experiments) can be stored here as articles or 
# files, word documents for example).
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class Assay < ActiveRecord::Base
  #
  # Add Catalog dictionary methods (lookup,like,name) based on the :name field
  #
  acts_as_dictionary :name 
  #
  #This item can be scheduled
  # 
  acts_as_scheduled :summary=>:experiments
  #
  # This record has a full audit log created for changes
  # 
  acts_as_audited :change_log

  # 
  # Generic rules for a name and description to be present
  # 
  validates_uniqueness_of :name,:case_sensitive=>false

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :project_id

  # 
  # Owner project
  # 
  acts_as_folder_linked :project, :under=>'assays'

  belongs_to :project  
  belongs_to :team
  

  #
  # Link to view for summary stats for assay
  # 
  has_many :stats, :class_name => "AssayStatistics"
  #
  # Assay Has a number of queues associated with it
  # 
  has_many :queues, :class_name => "AssayQueue",:dependent => :destroy

  # 
  #  has many project elements associated with it
  # 
  has_many :elements, :class_name=>'ProjectElement' ,:as => :reference, :dependent => :destroy
  #
  # The assay has a collection of protocols assocated with it
  # 
  has_many :protocols ,
    :class_name => "AssayProtocol",
    :foreign_key => "assay_id",
    :order => "assay_protocols.assay_stage_id desc",
    :dependent => :destroy do
    #
    # Limit protocols to only live in use versions
    #
    def live
      find(:all,:conditions=> <<SQL
       exists (select 1 from tasks,protocol_versions 
       where protocol_versions.id=tasks.protocol_version_id 
         and protocol_versions.assay_protocol_id=assay_protocols.id)
SQL
      )
    end     
  end

  has_many :workflows ,
    :class_name => "AssayWorkflow",
    :foreign_key => "assay_id"

  has_many :processes ,
    :class_name => "AssayProcess",
    :foreign_key => "assay_id"

  #   has_many 'analysis_methods' ,
  #   :class_name => "AnalysisDefinition",
  #   :foreign_key => "assay_id",
  #   :order => "assay_stage_id desc",
  #   :dependent => :destroy
 
  # ## List of experiments carried out for this assay
  # 
  has_many_scheduled :experiments,  :class_name=>'Experiment',
    :foreign_key =>'assay_id',:dependent => :destroy, :order => "experiments.name desc"

  # ## The assay has a collection of prefered parameters and roles assocated
  # with it
  # 
  has_many :parameters ,
    :class_name => "AssayParameter",
    :foreign_key => "assay_id",
    :include=>[:role,:parameter_type,:data_format,:data_element,:data_type],
    :order => "assay_parameters.name",
    :dependent => :destroy
  # 
  # make sure project and team are set
  # 
  def before_create 
    self.project ||= Project.current          
    self.team ||= Team.current
  end

  def initialize(options = {})
    super(options)      
    self.description = "<Please update with scope of assay definition>" if self.description.blank?
    Identifier.fill_defaults(self)    
    self.started_at  ||= Time.new
    self.expected_at ||= Time.new + 6.months
  end   
  
  # ## Get the named protocol from the list attrached to the assay
  # 
  def protocol(name)
    return self.protocols.detect{|i|i.name == name}
  end

  # ## Get the named experiment from the list attrached to the assay
  # 
  def experiment(name)
    return self.experiments.detect{|i|i.name == name}
  end
  # ## Get a list of all roles used in the assay
  # 
  def allowed_roles
    return parameters.collect{|p| p.role }.uniq
  end

  def style
    return 'Owned' if Project.current.id == self.project_id
    return "linked to #{self.project.name}" 
  end
  # ## Get all the parameters with this role in no role is specified then return
  # a unique list of parameters
  # 
  def parameters_for_role(role)
    if !role.nil? 
      role_id = role.is_a?(ParameterRole) ? role.id : role
      return self.parameters.find(:all,:conditions=>['parameter_role_id=?',role_id])
    else    
      return parameters
    end 
  end 
  # 
  # Path
  # 
  def path(scope='project')
    case scope.to_s
    when 'world','project'   then "#{project.name}:#{self.name}"
    when 'assay'   then self.name
    else self.name
    end
  end
  # 
  # Rules for sharing a assay
  # 
  def shareable?( other )
    (other.visible? and self.visible? and self.is_setup? and other.changeable?)
  end
  
  def shareable_status(other)
    return 'assay not no setup? ' unless self.is_setup?
    return "assay #{self.name} not visible for #{User.current}" unless self.visible?
    return "folder #{other.name}  not visible to #{self.name}" unless other.visible?
    return 'folder  #{other.name} not changable'  unless other.changeable?
    'ok'    
  end

  def runnable?
    Project.current.changeable? && is_setup? && process_instances.size>0
  end
  # 
  # Test if the assay is now setup
  # 
  def is_setup?
    has_parameters? and has_protocols?
  end
  
  def has_queues?
    self.queues.size>0
  end

  def has_protocols?
    self.protocols.size>0
  end
  
  def has_parameters?
    self.parameters.size>0
  end
  # ## Get all the parameters with this role in no role is specified then return
  # a unique list of parameters
  # 
  def parameters_for_data_type(data_type_id = 5)
    AssayParameter.find(:all,:conditions=>['assay_id=? and data_type_id=?',self.id,data_type_id])
  end 
  
  # 
  # 
  # 
  def has_parameter_of_data_type?(data_type_id = 5)
    !AssayParameter.find(:first,:conditions=>['assay_id=? and data_type_id=?',self.id,data_type_id]).nil?
  end
  # ## List all tasks assocated with this assay
  def tasks
    sql = "select t.* from tasks t,experiments e where e.id = t.experiment_id and e.assay_id = ?"
    return Task.find_by_sql([sql,self.id])
  end
  
  # ## get all protocols in a specific stage of the assay
  # 
  def protocols_in_stage( stage = nil )
    if !stage.nil? 
      return ProtocolVersion.find(:all,:include=>[:protocol], :conditions=>
          ["protocol_versions.status='released' and assay_protocols.assay_id = ? and assay_protocols.assay_stage_id=?",
          self.id, stage.id],  :order =>" assay_protocols.name ASC,protocol_versions.version DESC") 
    else    
      return protocols
    end 
  end   

  # ## get all protocols in a specific stage of the assay
  # 
  def queues_in_stage( stage = nil )
    if !stage.nil? 
      return queues.reject{|p| p.stage != stage}
    else    
      return queues
    end 
  end   
   
  # ## Get all the stages linked into this assay
  # 
  def stages
    AssayStage.find(:all)
  end

  # 
  # List of all the valid (released) process instances for this assay
  # 
  def process_instances(name=nil)    
    ProcessInstance.find(:all,:include=>[:protocol],
      :conditions=>["assay_protocols.assay_id=? 
                         and ( protocol_versions.status = 'released')  
                         and protocol_versions.name like ?" ,self.id,"#{name}%"])
  end
  # 
  # List of all the valid (released) process flows for this assay
  # 
  def process_flows(name=nil)
    ProcessFlow.find(:all,:include=>[:protocol],
      :conditions=>["assay_protocols.assay_id=? 
                         and ( protocol_versions.status = 'released')  
                         and protocol_versions.name like ?" ,self.id,"#{name}%"])
  end   
  # ## get all the ParameterRoles linked into this assay
  def parameter_roles(type = nil )
    if type
      ParameterRole.find_by_sql(
        ["SELECT * FROM parameter_roles a where exists (select 1 from assay_parameters b where b.parameter_role_id= a.id and b.assay_id=? and b.parameter_type_id=?)",id,type.id])
    else
      ParameterRole.find_by_sql(
        ["SELECT * FROM parameter_roles a where exists (select 1 from assay_parameters b where b.parameter_role_id= a.id and b.assay_id=?)",id])
    end 
  end

  # ## get all the ParameterType linked into this assay
  def parameter_types(role = nil)
    if role.is_a?(ParameterRole)
      ParameterRole.find_by_sql(
        ["SELECT * FROM parameter_types a where exists (select 1 from assay_parameters b  where b.parameter_type_id= a.id and b.parameter_role_id=? and b.assay_id=?)",role.id,id])     
    elsif role
      ParameterRole.find_by_sql(
        ["SELECT * FROM parameter_types a where exists (select 1 from assay_parameters b  where b.parameter_type_id= a.id and b.parameter_role_id=? and b.assay_id=?)",role,id])     
    else
      ParameterRole.find_by_sql(
        ["SELECT * FROM parameter_types a where exists (select 1 from assay_parameters b  where b.parameter_type_id= a.id and b.assay_id=?)",id])
    end
  end

  # ## Pivot assay parameters int of type v.s. roles hashed grid
  def parameter_grid
    last = 0
    columns = Hash.new
    grid = Hash.new
    for item in self.stats
      if last != item.parameter_type_id
        grid[last]= columns
        columns = Hash.new
        last= item.parameter_type_id
      end
      columns[item.parameter_role_id] = item
    end
    return grid
  end

  def export_parameters
    output = StringIO.new
    CSV::Writer.generate(output, ',') do |csv|
      csv << %w(parameter_id parameter_name role_id role_name name value type_id type_name format_id format_name unit description)
      self.parameters.each do |item|
        line = [item.type.id,      item.type.name,
          item.role.id,      item.role.name,
          item.name, item.default_value]                
        line << item.data_type.id 
        line << item.data_type.name
        if item.data_type_id=5 and item.data_element
          line << item.data_element.id 
          line << item.data_element.name         
        elsif item.data_format 
          line << item.data_format.id 
          line << item.data_format.name 
        end
        line << item.display_unit 
        line << item.description 
        csv << line
      end  
    end
    output.rewind
    return output
  end
  # 
  # Import a CSV file of parameters decoding the header row for column titles
  # 
  # 
  def import_parameters(file,create_types=false,create_roles=false)
    warnings=[]
    reader = CSV::Reader.create(file) 
    header = reader.shift
    lookup = Hash.new
    0.upto(header.size-1) do |col|     
      lookup[header[col]]=col
    end
    reader.each do |row|
      unless self.parameters.exists?({:name => row[lookup['name']]})
        begin
          assay_parameter = AssayParameter.new({:name => row[lookup['name']]})
          assay_parameter.type = locate(ParameterType, row[lookup['parameter_name']], row[lookup['parameter_id']] , create_types) 
          assay_parameter.role = locate(ParameterRole, row[lookup['role_name']], row[lookup['role_id']] , create_roles) 
          assay_parameter.data_type = locate(DataType, row[lookup['type_name']] ,row[lookup['type_id']] ,false)
          if 5 == assay_parameter.data_type_id
            assay_parameter.data_element = locate(DataElement, row[lookup['format_name']] , row[lookup['format_id']] , false)
          else
            assay_parameter.data_format = locate(DataFormat, row[lookup['format_name']] ,
              row[lookup['format_id']] , false)
          end                                                
          assay_parameter.name          = row[lookup['name']] 
          assay_parameter.description   = row[lookup['description']] if lookup['description'] and !row[lookup['description']].empty?
          assay_parameter.default_value = row[lookup['value']] if lookup['value']
          assay_parameter.display_unit  = row[lookup['unit']] if lookup['unit']
          assay_parameter.assay = self
          self.parameters << assay_parameter
          if assay_parameter.save
            logger.info "Added Assay Parameter #{assay_parameter.name}  to #{self.name}" 
          else
            logger.info "Failed to add Assay Parameter #{assay_parameter.name}  to #{self.name}" 
            logger.debug assay_parameter.errors.full_messages().uniq.join("\n")
            warnings << " Cant import row #{row.join(',')}"
            assay_parameter.errors.full_messages().uniq.each{|e|warnings << e}
          end
        rescue Exception => ex
          logger.error ex.message
          logger.debug ex.backtrace.join("\n") 
          warnings << "Error with row: #{row.join(',')} #{ex.message}"
        end 
      end
    end        
    return warnings        
  end
  
  def to_xml(options = {})
    my_options = options.dup
    my_options[:include] ||= [:parameters,:queues,:processes]
    Alces::XmlSerializer.new(self, my_options  ).to_s
  end

  # ## Get Assay from xml
  # 
  def self.from_xml(xml,options = {})
    my_options = options.dup
    my_options[:include] ||= [:parameters,:queues,:processes]
    Alces::XmlDeserializer.new(self,my_options ).to_object(xml)
  end
 
  # 
  # Custom data access object for user template engine liquid
  # 
  def to_liquid
    AssayDrop.new self
  end 
  protected
  # 
  # Helper function to locate match records for foreign key references for
  # import from a difference catalogue
  # 
  def locate(model, name, id = nil,create = false)
    object = nil
    logger.info("locate("+model.to_s+","+name+","+id.to_s+")")
    if name
      if id 
        object = model.find(id.to_i) 
        if object.name != name
          object = nil
        end
      else
        object = model.find_by_name(name)
      end
      if !object and create
        object = model.create({:name => name,:description => 'import generated '+name})
      end
    end 
    logger.info("Found "+object.name)
    return object 
  end

end
