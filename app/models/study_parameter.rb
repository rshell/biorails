# == Schema Information
# Schema version: 239
#
# Table name: study_parameters
#
#  id                :integer(11)   not null, primary key
#  parameter_type_id :integer(11)   
#  parameter_role_id :integer(11)   
#  study_id          :integer(11)   default(1)
#  name              :string(255)   
#  default_value     :string(255)   
#  data_element_id   :integer(11)   
#  data_type_id      :integer(11)   
#  data_format_id    :integer(11)   
#  description       :string(1024)  default(), not null
#  display_unit      :string(255)   
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
##
# As the list of parameters and roles will be rather large as part of a stury definition
# a sub set is choice and the value roles for them in the study are defined/
# This helps with later reporting to simply allow studies to be profiled.
#  
class StudyParameter < ActiveRecord::Base
  included Named
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_uniqueness_of :name,:scope=>'study_id'

  belongs_to :study   
  belongs_to :role,    :class_name =>'ParameterRole', :foreign_key=>'parameter_role_id'
  belongs_to :parameter_type
  belongs_to :data_type
  belongs_to :data_format
  belongs_to :data_element
  
  ##
  # Link in the study parameter with the protocols
  has_many :usages  ,:class_name =>'Parameter'
  
  ##
  # List of a unique contexts of usage for this parameter type
  has_many :contexts, :class_name =>'ParameterContext', :through => :usages
  
  validates_uniqueness_of :name, :scope => [:study_id]
  validates_presence_of :study_id
  validates_presence_of :parameter_type_id
  validates_presence_of :parameter_role_id
  validates_presence_of :data_type_id
  validates_presence_of :name
 
 def full_name
   self.name + "[" + role.name+"]"
 end


##
#Set the type
# cd ..
 def type=(type)  
   self.parameter_type = type
   if type
     self.data_type = type.data_type
     self.name = type.name
   end 
 end

##
# Return the type 
 def type
   return self.parameter_type
 end
 
 
  def mask
    return '.' if self.data_type_id == 5
    return self.data_format.format_regex if data_format   
  end

 
 def element
  if self.data_element.nil?    
    self.data_element = DataElement.find(:first,:conditions=>["data_concept_id=?",type.data_concept_id])
  end 
  return self.data_element
 end
 
 def concept
  if self.data_element.nil?    
     return self.type.data_concept
  end 
  return nil
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
