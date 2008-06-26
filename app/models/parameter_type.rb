# == Schema Information
# Schema version: 306
#
# Table name: parameter_types
#
#  id                 :integer(11)   not null, primary key
#  name               :string(50)    default(), not null
#  description        :string(1024)  default(), not null
#  weighing           :integer(11)   default(0), not null
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  data_concept_id    :integer(11)   
#  data_type_id       :integer(11)   
#  storage_unit       :string(255)   
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#

class ParameterType < ActiveRecord::Base
   acts_as_dictionary :name 
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :description
  validates_presence_of :data_type_id
  
  belongs_to :data_type
  belongs_to :data_concept
  
  has_many :aliases, :dependent => :destroy, :class_name=>'ParameterTypeAlias'    

    #
  # Linked Parameters 
  #
  has_many :parameters, :dependent => :destroy do    
     #
     # Limit set to contexts using the the a object
     #
     def using(item,in_use=false)
       template = 'parameters'
       if in_use
         template = "exists (select 1 from tasks where tasks.protocol_version_id = parameters.protocol_version_id) and #{template}"
       end
       case item
       when ProtocolVersion then  find(:all,:conditions=>["#{template}.protocol_version_id=?" ,item.id])
       when ParameterRole   then  find(:all,:conditions=>["#{template}.parameter_role_id=?" ,item.id])
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
  ##
  # List of a unique protocols
  has_many :roles, :class_name =>'ParameterRole', :through => :parameters ,:uniq=>true


  ##
  # List of a unique protocols
  has_many :processes, :class_name =>'ProtocolVersion', :through => :parameters,:uniq=>true do
    
     def live
         find(:all,:conditions=>'exists (select 1 from tasks where tasks.protocol_version_id = protocol_versions.id)')
     end
     #
     # Limit set to contexts using the the a object
     #
     def using(item,in_use=false)
       template = 'parameters'
       if in_use
         template = "exists (select 1 from tasks where tasks.protocol_version_id = protocol_versions.id) and #{template}"
       end
       case item
       when ParameterRole  then  find(:all,:conditions=>["#{template}.parameter_role_id=?" ,item.id])
       when ParameterContext then find(:all,:conditions=>["#{template}.parameter_context_id=?",item.id])
       when DataFormat     then  find(:all,:conditions=>["#{template}.data_format_id=?"    ,item.id])
       when DataType       then  find(:all,:conditions=>["#{template}.data_type_id=?"      ,item.id])
       when DataElement    then  find(:all,:conditions=>["#{template}.data_element_id=?"   ,item.id])
       when AssayQueue     then  find(:all,:conditions=>["#{template}.assay_queue_id=?"    ,item.id])
       else   
         []
       end  
     end 
   end    
  
  #
  # Assay Parameter linked to this type
  #
  has_many :assay_parameters, :dependent => :destroy do
     #
     # Limit set to contexts using the the a object
     #
     def using(item,in_use=false)
       template = 'assay_parameters'
       if in_use
         template = "exists (select 1 from parameters where assay_parameters.id = parameters.assay_parameter_id) and #{template}"
       end
       case item
       when ParameterRole  then  find(:all,:conditions=>["#{template}.parameter_role_id=?" ,item.id])
       when DataFormat     then  find(:all,:conditions=>["#{template}.data_format_id=?"    ,item.id])
       when DataType       then  find(:all,:conditions=>["#{template}.data_type_id=?"      ,item.id])
       when DataElement    then  find(:all,:conditions=>["#{template}.data_element_id=?"   ,item.id])
       else         
         find(:all)
       end  
     end                  
  end
   
#
# Find all parameters actualled used in a protocol
#
  def self.find_all_used
    self.find(:all,:conditions=>'exists (select 1 from parameters where parameters.parameter_type_id=parameter_types.id)')
  end    
  # 
  # See if the parameter is linked to a catalogue lookup
  # 
  def qualitive?
    (self.data_type_id == 5)
  end
##
# Get a string describing the style of the parameter in term of a data element or data format
# 
  def style
      if self.data_type_id==5
        "Lookup [#{self.data_concept.name}]" if self.data_concept
      else
        "#{data_type.name}" if data_type
      end
  end  
#
# add a alias
#
  def add_alias(name)
    self.aliases.create(:name=>name,:description=>self.description)    
  end
  
  #
  # ad a unique path for the parameter type
  #
  def path(scope=nil)
    name
  end

##
# Test usages of the parameter type
# 
  def not_used
    return (assay_parameters.size==0 and parameters.size==0)
  end 

#
# Test Whether this is in used in the database
#  
  def used?
    return (assay_parameters.size > 0 or  parameters.size>0)
  end 
#
# List all unit options with scalers for this parameter type
#
  def scaled_units
    if has_dimension?
         Unit.scaled_units(self.storage_unit)
    else 
         []
    end 
  end  
  # 
  # is custom unless has display_unit and this matches parameter_type
  # storage_unit
  # 
  def has_dimension?
    !self.storage_unit.blank?
  end
  #
  # List all units options for the paramerter tyep
  #
  def units
    if has_dimension?
       Unit.units(self.storage_unit)
    else 
       []
    end
  end  
#
# Work out the default unit for the parameter type
#
  def default_unit
    if has_dimension?
      list = units[0]
      list[0].to_unit.to_base.unit_name  if list.size>0
    else
      ""
    end
  end  

  def ParameterType.find_by_role(role)
    ParameterType.find_by_sql( ['select t.* from parameter_types t, assay_parameters s '+
     'where t.id = s.parameter_type_id and s.parameter_role_id = ? ',role.id])
  end          
  
  def to_xml(options = {})
      my_options = options.dup
      my_options[:include] ||= [:data_type]
      Alces::XmlSerializer.new(self, my_options  ).to_s
  end

##
# Get DataElement from xml
# 
  def self.from_xml(xml,options = {})
      my_options = options.dup
      my_options[:include] ||= [:data_type]
      Alces::XmlDeserializer.new(self,my_options ).to_object(xml)
  end

end
