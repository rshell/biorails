# == Schema Information
# Schema version: 233
#
# Table name: protocol_versions
#
#  id                :integer(11)   not null, primary key
#  study_protocol_id :integer(11)   
#  name              :string(77)    
#  version           :integer(6)    not null
#  lock_version      :integer(11)   default(0), not null
#  created_by        :string(32)    
#  created_at        :time          
#  updated_by        :string(32)    
#  updated_at        :time          
#  how_to            :text          
#  report_id         :integer(11)   
#  analysis_id       :integer(11)   
#

# == Schema Information
# Schema version: 123
#
# Table name: protocol_versions
#
#  id                :integer(11)   not null, primary key
#  study_protocol_id :integer(11)   
#  name              :string(77)    
#  version           :integer(6)    not null
#  lock_version      :integer(11)   default(0), not null
#  created_by        :string(32)    
#  created_at        :time          
#  updated_by        :string(32)    
#  updated_at        :time          
#  how_to            :text          
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
# This is hold in a collection of versions in of a ProcessDefinition
# 
 belongs_to :protocol, :class_name => 'StudyProtocol',:foreign_key =>'study_protocol_id'

##
# In term the instance is defined 
#
 has_many :parameters ,:include => [:data_format,:study_parameter], :order => ['parameter_context_id,column_no']

##
# Link to view for summary stats for study
# 
  has_many :stats, :class_name => "ProcessStatistics"

##
# In the Process sets of parameters are grouped into a context of usages
# 
 has_many :contexts, :class_name=>'ParameterContext', :dependent => :destroy

 has_many :roots, :class_name=>'ParameterContext',:conditions => 'parent_id is null'
 
 has_many :tasks, :dependent => :destroy
 
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
   for parameter in parameters
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
  
##
# Create a new context in this process 
 def new_context( parent  = nil)
    parameter_context = ParameterContext.new
    parameter_context.label =  "context"+contexts.size.to_s
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
   
      
end
