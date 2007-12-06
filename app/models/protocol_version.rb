# == Schema Information
# Schema version: 281
#
# Table name: protocol_versions
#
#  id                 :integer(11)   not null, primary key
#  study_protocol_id  :integer(11)   
#  name               :string(77)    
#  version            :integer(6)    not null
#  lock_version       :integer(11)   default(0), not null
#  created_at         :time          
#  updated_at         :time          
#  how_to             :text          
#  report_id          :integer(11)   
#  analysis_id        :integer(11)   
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#old ProtocolVersion rename to ProtocolVersion which is what is it represents. The ProtocolVersion is move a abstract contract it provides
#
class ProtocolVersion < ActiveRecord::Base

 validates_presence_of :protocol
 validates_presence_of :name
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log

##
# This is hold in a collection of versions in of a ProcessDefinition
# 
 belongs_to :protocol, :class_name => 'StudyProtocol',:foreign_key =>'study_protocol_id'

##
# Link to view for summary stats for study
# 
  has_many :stats, :class_name => "ProcessStatistics", :order => :id

##
# In the Process sets of parameters are grouped into a context of usages
# 
 has_many :contexts, :class_name=>'ParameterContext', :dependent => :destroy, :order => :id

 has_many :roots, :class_name=>'ParameterContext',:conditions => 'parent_id is null', :order => :id

 has_many :parameters, :class_name=>'Parameter',
          :include=>[:type,:role,:study_parameter,:data_format,:data_element], 
          :order => :column_no

 has_many :tasks, :dependent => :destroy, :order => :id

##
# Test if this instance is used in any tasks
 def is_used
    return self.tasks.size >0
 end 
##
#  
 def path
     if self.protocol
        self.protocol.name+':'+String(self.version)   
     else
        self.name
     end
 end  

##
# Resync the order of the columns
#   
 def resync_columns
   n=0
   for parameter in parameters.sort{|a,b|a.column_no <=>b.column_no}
      n +=1
      if parameter.column_no != n
        parameter.column_no = n  
        parameter.save
      end
   end
 end
 

 def definition
   self.protocol
 end

 def allowed_roles
     return self.protocol.study.allowed_roles
  end

 def max_columns
    if contexts && contexts.size>0
       sizes = contexts.collect{|context|context.parameters.size}
       return sizes.max
     end
     return 0
 end

##
# Default number of rows 
#   
 def default_rows
    n = 0
    for root in roots
       n += root.desendent_count
    end
    return n
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
# Create a new context in this process 
 def new_context( parent  = nil, name =nil)
    parameter_context = ParameterContext.new
    parameter_context.label =  name || "context"+contexts.size.to_s
    parameter_context.parent = parent if parent
    contexts << parameter_context
    return parameter_context
  end   
#
# get all the parameters in a specific role
   def role_parameters( role )
      if !role.nil? 
          return parameters.reject{|p| p.role != role}
      else    
          return parameters
      end 
   end

 # Create a new Implementation of the Process based on
 #
   def copy
       copy = protocol.new_version
       copy.name = self.name + "." + copy.version.to_s
       for old in self.roots
          copy.add_context(old)
       end 
       return copy
   end 
   
##
# Copy a context and all its children from source to current instance
#  * source = a context in a process to copy
#  * parent = context in current process to use a parent
#  
  def add_context(source , parent = nil)
     context = source.clone
     context.parent = parent
     context.id = nil
     self.contexts << context
     for child in source.children
        context.children << add_context(child,context)
     end
     for old in source.parameters
          parameter = old.clone
          parameter.id = nil
          context.parameters << parameter
          self.parameters << parameter
     end
     return context
   end      
   
 def to_xml(options = {})
     Alces::XmlSerializer.new(self, options.merge( {:include=> [:contexts]} )  ).to_s
 end
     
 ##
# Get from xml
# 
 def self.from_xml(xml,options = {} )
      my_options =options.dup
      my_options[:include] ||= [:contexts]
      Alces::XmlDeserializer.new(self,my_options ).to_object(xml)
 end  
     
end
