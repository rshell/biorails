# == Schema Information
# Schema version: 306
#
# Table name: parameters
#
#  id                   :integer(11)   not null, primary key
#  protocol_version_id  :integer(11)   not null
#  parameter_type_id    :integer(11)   not null
#  parameter_role_id    :integer(11)   not null
#  parameter_context_id :integer(11)   not null
#  column_no            :integer(11)   
#  sequence_num         :integer(11)   
#  name                 :string(62)    default(), not null
#  description          :string(1024)  
#  display_unit         :string(20)    
#  data_element_id      :integer(11)   
#  qualifier_style      :string(1)     
#  access_control_id    :integer(11)   default(0), not null
#  lock_version         :integer(11)   default(0), not null
#  created_at           :datetime      not null
#  updated_at           :datetime      not null
#  mandatory            :string(255)   default(N)
#  default_value        :string(255)   
#  data_type_id         :integer(11)   not null
#  data_format_id       :integer(11)   
#  assay_parameter_id   :integer(11)   not null
#  assay_queue_id       :integer(11)   
#  updated_by_user_id   :integer(11)   default(1), not null
#  created_by_user_id   :integer(11)   default(1), not null
#  left_limit           :integer(11)   default(0), not null
#  right_limit          :integer(11)   default(0), not null
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Parameter < ActiveRecord::Base

# validates_presence_of :protocol_version_id
 validates_uniqueness_of :name, :scope =>"protocol_version_id"
 validates_presence_of :parameter_type_id
 validates_presence_of :parameter_role_id
 validates_presence_of :assay_parameter_id
 validates_presence_of :data_type_id
 validates_presence_of :name
 validates_format_of :name, :with => /^[A-Z,a-z,0-9,_]*$/, :message => 'name is must be alphanumeric eg. [A-z,0-9,_]'

  validates_associated  :assay_parameter, 
    :if => Proc.new { | p | p.assay && p.assay_parameter && p.assay_parameter.assay == p.assay},
    :message => "Parameter is linked to a the wrong assay" 

 before_validation :fill_type_and_formating

##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log


 belongs_to :context, :class_name=>'ParameterContext',  :foreign_key =>'parameter_context_id'
 belongs_to :process, :class_name=>'ProcessInstance',  :foreign_key =>'protocol_version_id'
 belongs_to :role,    :class_name =>'ParameterRole',:foreign_key =>'parameter_role_id'
 belongs_to :type,    :class_name =>'ParameterType',:foreign_key =>'parameter_type_id'

##
# The Queue this request is linked too
# 
 belongs_to :queue, :class_name=>'AssayQueue', :foreign_key =>'assay_queue_id'

 belongs_to :assay_parameter, :class_name=>'AssayParameter', :foreign_key =>'assay_parameter_id'
 belongs_to :data_type
 belongs_to :data_format
 belongs_to :data_element
 
 has_many :task_values,     :dependent => :destroy
 has_many :task_references, :dependent => :destroy
 has_many :task_texts,      :dependent => :destroy
 has_many :analysis_settings, :dependent => :destroy

 def path(scope)
     out = "#{name} "  
     if self.queue
       out << "Queue:" << self.queue.name 
     else  
       out << "  ["
       out << self.role.name if self.role
       out << "/"
       out << self.type.name if self.type
       out << "]" 
     end
 end
 
  def mask
    return data_format.format_regex if data_format
    return '.'
  end
 #
 # parse a text string to a value
 #
 def parse(text)
    return data_format.parse( text,:unit=>self.display_unit)  if self.data_format
    return data_element.lookup(text) if self.data_element
    return text.to_s  
 end  
 #
 # format a value to a text string
 #
 def format(value)    
    return data_format.format(value,:unit=>self.display_unit)  if self.data_format
    return value.name if value.respond_to?(:name) and self.data_element
    return value.to_s
 end
 ##
 # helper to protocol
 #
  def protocol
    logger.info "finding protocol"
    self.process.protocol if self.process 
  end
 ##
 # helper to assay
 #
  def assay
    self.protocol.assay if self.protocol
  end
  
  def set(field, value = nil)
    eval(" self.#{field} = value")
  end
##
# Template the parameter
  def description
     out = ""
     if self.queue
       out << "Queue:" << self.queue.name 
     elsif self.assay_parameter
       out << "Parameter " 
     end
     out << "  ["
     out << self.role.name if self.role
     out << "/"
     out << self.type.name if self.type
     out << "]"  
  end
  
 #
 # reorder columns 
  def after(parameter)
    return self if parameter.column_no == self.column_no
    from = [parameter.column_no,self.column_no].min
    to = [parameter.column_no,self.column_no].max
    if parameter.column_no == from
        process.parameters.each do |item|
           if item == parameter
           elsif item == self
              item.column_no = from + 1
              item.save

           elsif ((item.column_no > from) && (item.column_no < to))
              item.column_no += 1
              item.save
           end
        end
      else
        process.parameters.each do |item|
           if item == self
              item.column_no = to
              item.save
         elsif item == parameter
              item.column_no -= 1
              item.save
           elsif ((item.column_no > from) && (item.column_no < to))
              item.column_no -= 1
              item.save
           end
        end
    end      
    return self.column_no
  end
##
# Get a string describing the style of the parameter in term of a data element or data format
# 
  def style
      if self.data_type_id==5
        self.data_element.name if self.data_element
      else
        data_format.name if data_format
      end
  end
  
    
 def element
  self.data_element ||= DataElement.find(:first,:conditions=>["data_concept_id=?",type.data_concept_id])
  return self.data_element
 end
 #
 # Storage Dimension
 # 
 def storage_unit
   type.storage_unit if self.type
 end

##
# fill in any missing format or type information based on assay defaults
 def fill_type_and_formating   
   if self.assay_parameter
       self.name ||= self.assay_parameter.name 
       self.data_type_id ||= self.assay_parameter.data_type_id 
       self.parameter_type_id ||= self.assay_parameter.parameter_type_id 
       self.parameter_role_id ||= self.assay_parameter.parameter_role_id 
       self.data_element_id ||= self.assay_parameter.data_element_id
       self.data_format_id ||= self.assay_parameter.data_format_id
       self.default_value ||= self.assay_parameter.default_value
       self.display_unit ||= self.assay_parameter.display_unit
   end
   self.protocol_version_id ||= self.context.protocol_version_id if self.context
  end
 
 def to_xml(options = {})
      my_options = options.dup
      my_options[:reference] = {:assay_queue=>:name,:assay_parameter=>:name,:type=>:name,:role=>:name,:data_format=>:name,:data_element=>:name}
      my_options[:except] = [:protocol_version_id,:assay_queue_id,:assay_parameter_id,:parameter_type_id,:parameter_role_id,:data_format_id,:data_element_id]   
     Alces::XmlSerializer.new(self,my_options ).to_s
 end

 ##
 # Get from xml
 # Lookup the references to catalogue by name was may be in a difference database
 # 
 def self.from_xml(xml,options ={} )
      my_options = options.dup
      my_options[:reference] = {:assay_queue=>:name,:assay_parameter=>:name,:type=>:name,:role=>:name,:data_format=>:name,:data_element=>:name}
      Alces::XmlDeserializer.new(self,my_options ).to_object(xml)
 end  
     
end
