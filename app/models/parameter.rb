# == Schema Information
# Schema version: 281
#
# Table name: parameters
#
#  id                   :integer(11)   not null, primary key
#  protocol_version_id  :integer(11)   
#  parameter_type_id    :integer(11)   
#  parameter_role_id    :integer(11)   
#  parameter_context_id :integer(11)   
#  column_no            :integer(11)   
#  sequence_num         :integer(11)   
#  name                 :string(62)    
#  description          :string(62)    
#  display_unit         :string(20)    
#  data_element_id      :integer(11)   
#  qualifier_style      :string(1)     
#  access_control_id    :integer(11)   default(0), not null
#  lock_version         :integer(11)   default(0), not null
#  created_at           :datetime      not null
#  updated_at           :datetime      not null
#  mandatory            :string(255)   default(N)
#  default_value        :string(255)   
#  data_type_id         :integer(11)   
#  data_format_id       :integer(11)   
#  study_parameter_id   :integer(11)   
#  study_queue_id       :integer(11)   
#  updated_by_user_id   :integer(11)   default(1), not null
#  created_by_user_id   :integer(11)   default(1), not null
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
 validates_presence_of :study_parameter_id
 validates_presence_of :data_type_id
 validates_presence_of :name
 validates_associated  :study_parameter, 
    :if => Proc.new { | p | p.study && p.study_parameter && p.study_parameter.study == p.study},
    :message => "Parameter is linked to a the wrong study" 

 before_validation :fill_type_and_formating

##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log


 belongs_to :context, :class_name=>'ParameterContext',  :foreign_key =>'parameter_context_id'
 belongs_to :process, :class_name=>'ProtocolVersion',  :foreign_key =>'protocol_version_id'
 belongs_to :role,    :class_name =>'ParameterRole',:foreign_key =>'parameter_role_id'
 belongs_to :type,    :class_name =>'ParameterType',:foreign_key =>'parameter_type_id'

##
# The Queue this request is linked too
# 
 belongs_to :queue, :class_name=>'StudyQueue', :foreign_key =>'study_queue_id'

 belongs_to :study_parameter, :class_name=>'StudyParameter', :foreign_key =>'study_parameter_id'
 belongs_to :data_type
 belongs_to :data_format
 belongs_to :data_element
 
 has_many :task_values,     :dependent => :destroy
 has_many :task_references, :dependent => :destroy
 has_many :task_texts,      :dependent => :destroy
 
 
  def mask
    return data_format.format_regex if data_format
    return '.'
  end
 ##
 # helper to protocol
 #
  def protocol
    logger.info "finding protocol"
    self.process.protocol if self.process 
  end
 ##
 # helper to study
 #
  def study
    self.protocol.study if self.protocol
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
     elsif self.study_parameter
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

 def storage_unit
   type.storage_unit
 end

##
# fill in any missing format or type information based on study defaults
 def fill_type_and_formating   
   if self.study_parameter
       self.name ||= self.study_parameter.name 
       self.data_type_id ||= self.study_parameter.data_type_id 
       self.parameter_type_id ||= self.study_parameter.parameter_type_id 
       self.parameter_role_id ||= self.study_parameter.parameter_role_id 
       self.data_element_id ||= self.study_parameter.data_element_id
       self.data_format_id ||= self.study_parameter.data_format_id
       self.default_value ||= self.study_parameter.default_value
       self.display_unit ||= self.study_parameter.display_unit
   end
   self.protocol_version_id ||= self.context.protocol_version_id if self.context
  end
 
 def to_xml(options = {})
      my_options = options.dup
      my_options[:reference] = {:study_queue=>:name,:study_parameter=>:name,:type=>:name,:role=>:name,:data_format=>:name,:data_element=>:name}
      my_options[:except] = [:protocol_version_id,:study_queue_id,:study_parameter_id,:parameter_type_id,:parameter_role_id,:data_format_id,:data_element_id]   
     Alces::XmlSerializer.new(self,my_options ).to_s
 end

 ##
 # Get from xml
 # Lookup the references to catalogue by name was may be in a difference database
 # 
 def self.from_xml(xml,options ={} )
      my_options = options.dup
      my_options[:reference] = {:study_queue=>:name,:study_parameter=>:name,:type=>:name,:role=>:name,:data_format=>:name,:data_element=>:name}
      Alces::XmlDeserializer.new(self,my_options ).to_object(xml)
 end  

  def units
    if self.parameter_type 
       Unit.Units(self.parameter_type.storage_unit)
    else
       Unit.UNITS_LOOKUP
    end
  end
     
end
