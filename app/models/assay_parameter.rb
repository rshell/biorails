# == Schema Information
# Schema version: 306
# 
# Table name: assay_parameters
# 
#  id                 :integer(11)   not null, primary key
#  parameter_type_id  :integer(11)   not null
#  parameter_role_id  :integer(11)   not null
#  assay_id           :integer(11)   default(1)
#  name               :string(255)   default(), not null
#  default_value      :string(255)
#  data_element_id    :integer(11)
#  data_type_id       :integer(11)   not null
#  data_format_id     :integer(11)
#  description        :string(1024)  default(), not null
#  display_unit       :string(255)
#  created_by_user_id :integer(11)   default(1), not null
#  updated_by_user_id :integer(11)   default(1), not null
# 

# ##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
# 
# ## As the list of parameters and roles will be rather large as part of a stury
# definition a sub set is choice and the value roles for them in the assay are
# defined/ This helps with later reporting to simply allow assays to be
# profiled.
# 
class AssayParameter < ActiveRecord::Base

  acts_as_dictionary :name 
  # 
  # Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :assay_id
  validates_presence_of :parameter_type_id
  validates_presence_of :parameter_role_id
  validates_presence_of :data_type_id
  validates_presence_of :data_element_id, :if => :qualitive?

  validates_uniqueness_of :name, :scope => [:assay_id]
  validates_format_of :name, :with => /^[A-Z,a-z,0-9,_]*$/, :message => 'name is must be alphanumeric eg. [A-z,0-9,_]'


  # ## This record has a full audit log created for changes
  # 
  acts_as_audited :change_log
  acts_as_ferret  :fields => {:name =>{:boost=>2,:store=>:yes} , 
    :description=>{:store=>:yes,:boost=>0},
  }, 
    :default_field => [:name],           
    :single_index => true, 
    :store_class_name => true 

  belongs_to :assay   
  belongs_to :role,    :class_name =>'ParameterRole', :foreign_key=>'parameter_role_id'
  belongs_to :parameter_type
  belongs_to :data_type
  belongs_to :data_format
  belongs_to :data_element
  
  # ## Link in the assay parameter with the protocols
  has_many :parameters  ,:class_name =>'Parameter' do    
    # 
    # Limit set to contexts using the the a object
    # 
    def using(item,in_use=false)
      template = 'parameters'
      if in_use
        template = "exists (select 1 from tasks where tasks.protocol_version_id = parameters.protocol_version_id) and #{template}"
      end
      case item
      when ParameterType  then  find(:all,:conditions=>["#{template}.parameter_type_id=?" ,item.id])
      when ParameterRole  then  find(:all,:conditions=>["#{template}.parameter_role_id=?" ,item.id])
      when AssayParameter then  find(:all,:conditions=>["#{template}.assay_parameter_id=?",item.id])
      when DataFormat     then  find(:all,:conditions=>["#{template}.data_format_id=?"    ,item.id])
      when DataType       then  find(:all,:conditions=>["#{template}.data_type_id=?"      ,item.id])
      when DataElement    then  find(:all,:conditions=>["#{template}.data_element_id=?"   ,item.id])
      when AssayQueue     then  find(:all,:conditions=>["#{template}.assay_queue_id=?"    ,item.id])
      else         
        find(:all)
      end  
    end 
  end
  
  # ## List of a unique contexts of usage for this parameter type
  has_many :contexts, :class_name =>'ParameterContext', :through => :parameters,:uniq=>true do
     
    # 
    # Limit set to contexts using the the a object
    # 
    def using(item,in_use=false)
      template = 'parameters'
      if in_use
        template = "exists (select 1 from tasks where tasks.protocol_version_id = parameters.protocol_version_id) and #{template}"
      end
      case item
      when ParameterType  then  find(:all,:conditions=>["#{template}.parameter_type_id=?" ,item.id])
      when ParameterRole  then  find(:all,:conditions=>["#{template}.parameter_role_id=?" ,item.id])
      when AssayParameter then  find(:all,:conditions=>["#{template}.assay_parameter_id=?",item.id])
      when DataFormat     then  find(:all,:conditions=>["#{template}.data_format_id=?"    ,item.id])
      when DataType       then  find(:all,:conditions=>["#{template}.data_type_id=?"      ,item.id])
      when DataElement    then  find(:all,:conditions=>["#{template}.data_element_id=?"   ,item.id])
      when AssayQueue     then  find(:all,:conditions=>["#{template}.assay_queue_id=?"    ,item.id])
      else         
        find(:all)
      end  
    end 
  end
 
  
  # ## List of a unique protocols
  has_many :processes, :class_name =>'ProtocolVersion', :through => :parameters,:uniq=>true do
     
    # 
    # Limit set to contexts using the the a object
    # 
    def using(item,in_use=false)
      template = 'parameters'
      if in_use
        template = "exists (select 1 from tasks where tasks.protocol_version_id = parameters.protocol_version_id) and #{template}"
      end
      case item
      when ParameterType  then  find(:all,:conditions=>["#{template}.parameter_type_id=?" ,item.id])
      when ParameterRole  then  find(:all,:conditions=>["#{template}.parameter_role_id=?" ,item.id])
      when ParameterContext then  find(:all,:conditions=>["#{template}.parameter_context_id=?",item.id])
      when DataFormat     then  find(:all,:conditions=>["#{template}.data_format_id=?"    ,item.id])
      when DataType       then  find(:all,:conditions=>["#{template}.data_type_id=?"      ,item.id])
      when DataElement    then  find(:all,:conditions=>["#{template}.data_element_id=?"   ,item.id])
      when AssayQueue     then  find(:all,:conditions=>["#{template}.assay_queue_id=?"    ,item.id])
      else         
        find(:all)
      end  
    end 
  end 
 
  # 
  # alias for parameters collection as represent usage of a assay_parameter
  # 
  def usages
    return self.parameters
  end 
  # 
  # See if the parameter is linked to a catalogue lookup
  # 
  def qualitive?
    data_type_id == 5
  end
  # 
  # full name of the parameter with the role name added to better describe the
  # value in the UI
  # 
  def full_name
    self.name + "[" + role.name+"]"
  end

  # 
  # Path
  # 
  def path(scope='assay')
    case scope.to_s
    when 'world','project' then "#{assay.path(scope)}/#{self.name}"
    when 'root','assay','parameters' then "#{assay.name}/#{self.name}"
    else 
      self.name
    end
  end

  #
  # Configure the parameter to match a parameter type
  #
  def type=(type)  
    self.parameter_type = type
    if type
      self.data_type = type.data_type
      self.name = type.name
      self.description = type.description
    end 
  end
  # 
  # Return the parameter type
  #
  def type
    return self.parameter_type
  end
  #
  # Simple test if the parameter has actually been used in a process
  #
  def used?
    return self.parameters.find(:first)
  end
 
  def units
    if self.parameter_type
      if self.parameter_type.storage_unit
        Unit.scaled_units(self.parameter_type.storage_unit)
      else 
        []
      end
    else
      Unit::UNITS_LOOKUP
    end
  end
  # 
  # is custom unless has display_unit and this matches parameter_type
  # storage_unit
  # 
  def custom?
    self.parameter_type.storage_unit.nil? || self.parameter_type.storage_unit.empty?
  end
  #
  # mask for data entry
  #
  def mask
    return self.data_format.mask if data_format   
    '(.*)'
  end
 
  # 
  # Simple value parser
  # 
  def parse(new_value)  
    value = new_value
    case self.data_type.id
   
    when Biorails::Type::DATE
      value =  DateTime.strptime(new_value,"%Y-%m-%d")
     
    when Biorails::Type::NUMERIC
      value = Unit.new(new_value)
      value = Unit.new(new_value,self.display_unit)  if value.units == "" and self.display_unit 

    when Biorails::Type::TIME
      value =  DateTime.strptime(new_value,"%Y-%m-%d %H:%M:%S")

    when Biorails::Type::DICTIONARY
      value = element.lookup(new_value)
    end
    logger.info "parsed #{new_value} => #{value}"
    return value
  end 
  # 
  # Use another object as a template
  # 
  def use_template(template)
    if template     
      self.name = template.name 
      self.description =  template.description
      self.role =  template.parameter_role
      self.data_element =  template.data_element
      self.data_format  =  template.data_format
      self.display_unit =  template.display_unit
    end
  rescue Exception => ex
    logger.warn("Poor choice of object for assay_parameter.use_template(xxx) as failed #{ex.message}")
  end
  # 
  # Get the linked data element
  #
  def element
    if self.data_element.nil? and type.data_concept_id  
      self.data_element = DataElement.find(:first,:order=>'id desc',:conditions=>["parent_id is null and data_concept_id=?",type.data_concept_id])
    end 
    return self.data_element
  end
  #
  # format a value based on rules for this parameter
  #
  def format(value)    
    return data_format.format( value)  if self.data_format
    return value.name if value.respond_to?(:name)
    return value.to_s
  end
  #
  # get the linked concept
  #
  def concept
    return self.type.data_concept if self.data_element.nil?
    nil
  end
 
  # ## Get a string describing the style of the parameter in term of a data
  # element or data format
  # 
  def style
    return self.type.style if self.type
    "Undefined"
  end
  # ## Convert context to xml
  # 
  def to_xml(options={})
    my_options = options.dup
    my_options[:reference] = {:data_type=>:name,:parameter_type=>:name,:role=>:name,:data_format=>'name',:data_element=>'name'}
    my_options[:except] = [:parameter_type_id, :parameter_role_id, :data_format_id, :data_element_id] +  options[:except]
    Alces::XmlSerializer.new(self, my_options  ).to_s
  end 
   
  # ## Get from xml
  # 
  def self.from_xml(xml,options = {})      
    my_options = options.dup
    my_options[:reference] = {:data_type=>:name,:parameter_type=>:name,:role=>:name,:data_format=>'name',:data_element=>'name'}
    Alces::XmlDeserializer.new(self, my_options ).to_object(xml)
  end
 
end
