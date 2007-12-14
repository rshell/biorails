# == Schema Information
# Schema version: 281
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
 validates_presence_of :protocol_version_id
 validates_presence_of :label
 validates_presence_of :default_count

 belongs_to :process, :class_name=>'ProtocolVersion',:foreign_key=>'protocol_version_id'

 acts_as_fast_nested_set :parent_column => 'parent_id',
                     :left_column => 'left_limit',
                     :right_column => 'right_limit',
                     :order => 'protocol_version_id,left_limit',
                     :scope => :protocol_version_id,
                     :text_column => 'label' 
 
 @@default_columns = 64
##
# In term the context is defined 
#
 has_many :parameters,  :class_name=>'Parameter',
                        :foreign_key =>'parameter_context_id', 
                        :dependent => :destroy,
                        :include=>[:type,:role,:study_parameter,:data_format,:data_element], 
                        :order => 'column_no'

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
 
 
 def parameter(name)
    case name
    when Fixnum
      return parameters.detect{|item|item.id == name}   
    else
      return parameters.detect{|item|item.name == name.to_s}   
    end
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
    logger.info "Parameter Create [#{definition.name}] in context [#{self.label}]"
    return nil if definition.nil?
    parameter = Parameter.new
    parameter.study_parameter = definition
    parameter.sequence_num    =  0 
    parameter.context = self
    parameter.name = definition.name
    parameter.fill_type_and_formating
    while Parameter.find(:first, :conditions => 
            ["protocol_version_id=? and name=?", self.process.id, parameter.name])
       parameter.sequence_num +=1
       parameter.name = definition.name + '_'+String(parameter.sequence_num )             
    end
    self.process.parameters << parameter 
    self.parameters << parameter    
    parameter.column_no = self.process.parameters.size 
    logger.info "Parameter Created [#{parameter.name}] in context [#{self.label}]"
    return parameter
    
  rescue Exception => ex
      logger.error ex.message
      logger.error ex.backtrace.join("\n")
 end
  
##
#  
 def add_queue( queue)
    return nil unless queue and queue.parameter
    logger.info "Queue Parameter Create [#{queue.name}] in context [#{self.label}]"
    parameter = add_parameter(queue.parameter)
    parameter.queue = queue
    return parameter
 end
   
 
 def to_xml(options = {})
     Alces::XmlSerializer.new(self, options.merge( {:include=> [:parameters]} )  ).to_s
 end

 ##
# Get from xml
# 
 def self.from_xml(xml,options ={} )
      my_options = options.dup
      my_options[:include] = [:parameters]
 
      Alces::XmlDeserializer.new(self,my_options ).to_object(xml)
 end 
#
# Get default count of expected totals rows for this context type
#
 def default_total
   if parent
     parent.default_total * self.default_count      
   else  
     self.default_count    
   end     
 end
 #
 # Get default row labels for expected context in use
 #
 def default_labels
   labels =[]
   if parent
     parent.default_labels.collect do |i|
        0.upto(self.default_count-1) do |n|
         labels << "#{i}/#{label}[#{n}]"
       end          
     end
   else  
      0.upto(self.default_count-1) do |n|
       labels << "#{label}[#{n}]"
     end   
   end
   return labels
 end 
 #
 # Get default row values as a hash by parameter id
 #     
 def default_row
   values ={}
   self.parameters.each do |parameter|
     values[parameter.id] = parameter.default_value
   end   
   return values   
 end
#
# Get expected total data block
#
 def default_block
   values = default_row
   block ={}
   default_labels.each do |n|
     block[n] = values
   end    
   return block
 end
 
end
