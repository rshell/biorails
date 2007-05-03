# == Schema Information
# Schema version: 239
#
# Table name: parameter_contexts
#
#  id                  :integer(11)   not null, primary key
#  protocol_version_id :integer(11)   
#  parent_id           :integer(11)   
#  level_no            :integer(11)   default(0)
#  label               :string(255)   
#  default_count       :integer(11)   default(1)
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
##
# This defined a shared context between a number of parameters in data entry. It is used
# to link up values into a subject context like plate ,sample or well level results.
# 
class ParameterContext < ActiveRecord::Base

 validates_uniqueness_of :label, :scope =>"protocol_version_id"
 validates_presence_of :label
 validates_presence_of :default_count

 belongs_to :process, :class_name=>'ProtocolVersion',:foreign_key=>'protocol_version_id'

 acts_as_tree :order => "id"  
 
 @@default_columns = 64
##
# In term the context is defined 
#
 has_many :parameters,  :class_name=>'Parameter',:foreign_key =>'parameter_context_id', :dependent => :destroy, :order => 'column_no'

##
# Link to actual result row. Have to be careful here as there may be 1000s ofrows here.
# 
 has_many :usages, :class_name=>'TaskContext',:foreign_key =>'parameter_content_id'
##
# path to name
#
  def path
     if parent == nil 
        return label 
     else 
        return parent.path+"/"+label
     end 
  end 

##
# string to show how many of this contexts to expected eg. 5 x 6 x 54
# 
  def count_string
     if parent == nil 
        return ' x'+self.default_count.to_s 
     else 
        return parent.count_string+'x'+self.default_count.to_s
     end 

  end
##
# See in the the passed record in related to this one (eg. parent or self)
# 
 def is_related(other)
    if self == other
       return true
    elsif parent
       return parent.is_related(other)
    end
    return false
 end
 
 
 def allowed_parents
     list = [["",nil]] 
     process.contexts.each do |item|
         list.concat( [[item.label,item.id]]) if !item.is_related(self)
     end
     return list
 end
##
# desendants summed up
# 
 def desendent_count
    n = default_count
    for child in children
       n *= child.desendent_count
    end
    return n
 end
 
 def fill_columns
   @@default_columns - parameters.size
 end

 def self.default_columns
   @@default_columns
 end
 
 def self.default_columns=(value)
   @@default_columns = value
 end

##
# Setup Parameter with default from study with unqiue name generation and 
# addition to the protocol.
# 
#  * definition is a Parameter or Study_parameter to use a source definition
#  * context is the protocol context to add the created parameter to (effects name generation) 
#  
  def add_parameter( definition )
    return nil if definition.nil?
    logger.info "Parameter Create [#{definition.name}] in context [#{self.label}]"
    parameter = Parameter.new
    parameter.study_parameter = definition
    parameter.fill_type_and_formating
    parameter.sequence_num    =  0 
    while Parameter.find(:first, :conditions => 
            ["protocol_version_id=? and name=?", self.process.id, parameter.name])
       parameter.sequence_num +=1
       parameter.name = definition.name + '_'+String(parameter.sequence_num )             
    end
    self.process.parameters << parameter 
    self.parameters << parameter    
    parameter.column_no = self.process.parameters.size 
    return parameter
    
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")
  end
  
##
#  
  def add_queue( queue)
    logger.info "Queue Parameter Create [#{queue.name}] in context [#{self.label}]"
    parameter = add_parameter(queue.parameter)
    parameter.queue = queue
    return parameter
  end
  
##
# Convert context to xml
  def to_xml( xml = Builder::XmlMarkup.new)
   xml.context(:id =>id, :label => label, :rows => default_count) do
     xml.parent(parent_id) if parent_id
     xml.parameters do
       for parameter in parameters
         parameter.to_xml(xml)
       end  
     end
     for child in children
         child.to_xml(xml)
     end
   end
   return xml
  end 
  
end
