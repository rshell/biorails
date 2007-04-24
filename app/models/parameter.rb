# == Schema Information
# Schema version: 239
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

# == Schema Information
# Schema version: 233
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
#  created_by           :string(32)    default(), not null
#  created_at           :datetime      not null
#  updated_by           :string(32)    default(), not null
#  updated_at           :datetime      not null
#  mandatory            :string(255)   default(N)
#  default_value        :string(255)   
#  data_type_id         :integer(11)   
#  data_format_id       :integer(11)   
#  study_parameter_id   :integer(11)   
#  study_queue_id       :integer(11)   
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class Parameter < ActiveRecord::Base
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log


 validates_uniqueness_of :name, :scope =>"protocol_version_id"

 belongs_to :context, :class_name=>'ParameterContext',  :foreign_key =>'parameter_context_id'
 belongs_to :process, :class_name =>'ProtocolVersion',:foreign_key =>'protocol_version_id'
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

 validates_presence_of :protocol_version_id
 validates_presence_of :parameter_type_id
 validates_presence_of :parameter_role_id
 validates_presence_of :study_parameter_id
 validates_presence_of :data_type_id
 validates_presence_of :name
 
# before_validation :fill_type_and_formating
 
 
  def mask
    return data_format.format_regex if data_format
    return '.'
  end

##
# Template the parameter
  def description
     out = ""
     if queue
     out << "Queue:" << queue.name 
     elsif study_parameter
     out << "Parameter " 
     end
     out <<"  ["
     out << role.name if role
     out << "/"
     out << type.name if type
     out << "]"  
  end
##
# Get a string describing the style of the parameter in term of a data element or data format
# 
  def style
      if data_type==5
        data_element.name if data_element
      else
        data_format.name if data_format
      end
  end
  
 def element
  self.data_element ||= DataElement.find(:first,:conditions=>["data_concept_id=?",type.data_concept_id])
  return self.data_element
 end

##
# fill in any missing format or type information based on study defaults
 def fill_type_and_formating   
   self.name ||= self.study_parameter.name 
   self.data_type_id ||= self.study_parameter.data_type_id 
   self.parameter_type_id ||= self.study_parameter.parameter_type_id 
   self.parameter_role_id ||= self.study_parameter.parameter_role_id 
   self.data_element_id ||= self.study_parameter.data_element_id
   self.data_format_id ||= self.study_parameter.data_format_id
   self.default_value ||= self.study_parameter.default_value
   self.display_unit ||= self.study_parameter.display_unit
  end

##
# Convert context to xml
# 
 def to_xml( xml = Builder::XmlMarkup.new)
   xml.parameter(:id => id, :name => name) do
       xml.type(:id=>type.id, :name=>type.name) if type
       xml.role(:id=> role.id,:name=> role.name) if role
       xml.datatype(:id=> data_type.id,   :name=> data_type.name) if data_type
       xml.lookup(  :id=> data_element.id,:name=> data_element.name) if data_element
       xml.format(  :id=> data_format.id, :name=> data_format.name) if data_format
       xml.default(default_value) if default_value
   end
   return xml
 end 
   
end
