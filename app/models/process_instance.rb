#
# Implementation of single process implementation
# represents leaf objects in the composition
# implements all ProtocolVersion methods
# This is basically the same as ProtocolVersion in the previous versions <307 of the data model
#
# A process instance is built of a collection of parameters each with a role and a type
# For management of complex data structures the parameters are grouped into a tree of 
# contexts.
#
#
class ProcessInstance < ProtocolVersion
    #
    # Default analysis method associated with this protocol
    #    
    belongs_to :analysis_method,   :class_name =>'AnalysisMethod'
    #
    # Default report to show for task
    #
    belongs_to :report,   :class_name =>'Report'

  #
  # In the Process sets of parameters are grouped into a context of usages
  # 
    has_many :contexts, 
             :class_name=>'ParameterContext',
             :foreign_key=>'protocol_version_id', 
             :dependent => :destroy, 
             :order => :id do         
     #
     # Limit set to contexts using the the a object
     #
     def using(item,in_use=false)
       template = 'exists (select 1 from parameters where parameters.parameter_context_id=parameter_contexts.id and parameters'
       if in_use
         template = "exists (select 1 from task_contexts where task_contexts.parameter_context_id = parameter_contexts.id) and #{template}"
       end
       case item
       when ParameterType  then  find(:all,:conditions=>["#{template}.parameter_type_id=?)" ,item.id])
       when ParameterRole  then  find(:all,:conditions=>["#{template}.parameter_role_id=?)" ,item.id])
       when AssayParameter then  find(:all,:conditions=>["#{template}.assay_parameter_id=?)",item.id])
       when DataFormat     then  find(:all,:conditions=>["#{template}.data_format_id=?)"    ,item.id])
       when DataType       then  find(:all,:conditions=>["#{template}.data_type_id=?)"      ,item.id])
       when DataElement    then  find(:all,:conditions=>["#{template}.data_element_id=?)"   ,item.id])
       when AssayQueue     then  find(:all,:conditions=>["#{template}.assay_queue_id=?)"    ,item.id])
       else         
         find(:all)
       end  
     end  
    
    end
#
# base root for contruction of parameter tree (99% single root)
#
    has_many :roots, 
             :class_name=>'ParameterContext',
             :foreign_key=>'protocol_version_id', 
             :conditions => 'parent_id is null', :order => :id

   ##
   # Link to view for summary stats for assay
   # 
    has_many :stats, 
             :class_name => "ProcessStatistics", 
             :foreign_key=>'protocol_version_id',
             :order => :id

#
# List of all parameter  forming the basic column strucutre for data entry grid
#
    has_many :parameters, 
             :class_name=>'Parameter',
             :dependent => :destroy, 
             :foreign_key=>'protocol_version_id',
             :include=>[:type,:role,:assay_parameter,:data_format,:data_element], 
             :order => :column_no do
     #
     # queue linked parameters
     #
     def queued
       find(:all,:include=>[:queue,:type,:role,:assay_parameter,:data_element],:conditions=>'assay_queue_id is not null')
     end
     #
     # dictionary based parameters
     #
     def dictionary_based
       find(:all,:conditions=>'data_element_id is not null')
     end
     #
     # Parameters of a set data type
     #
     def type(n)
       find(:all,:conditions=>['data_type_id =?',n])
     end
     #
     # Limit set to contexts using the the a object
     #
     def using(item,in_use=false)
       template = 'parameters'
       if in_use
         template = "exists (select 1 from task_contexts where task_contexts.parameter_context_id = parameters.parameter_context_id) and #{template}"
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
         find(:all,:conditions=>["#{template}.name=?","#{item}%"])
       end  
     end     
             
    end
#
# List of usages of the workflow 
#
 def usages
   self.tasks || []
 end   
 
 #
# are there queues associated with this process
#
 def queues?
   self.parameters.queued.size > 0
 end
 #
 # List of queues associated with this process
 #
 def queues
   self.parameters(:all,:include=>[:queue],:conditions=>'assay_queue_id is not null').collect{|i|i.queue}
 end

 #
 # dummy get parameters
 #
 def steps
   [self]
 end

##
# Test if this instance is used in any tasks
 def used?
    return self.tasks.size >0
 end 
#
# Test whether a new version of the protocol is to allow
# dynamic editing.
#

 def flexible?
    return ((self.tasks.size < 2) and !released?)
 end
##
# get a list of titles of columns for returned data grid
# 
  def names
    self.parameters.collect{|item|item.name}
  end

##
#  Styles of column for returned data grid
#  
  def styles
    self.parameters.collect{|item|item.style}
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
#
# Get a matching parameter in the process
#
 def parameter(key)
    case key
    when Fixnum
      return parameters.detect{|item|item.id == key}   
    when Parameter
      return parameters.detect{|item|item.id == key.id}   
    when TaskValue,TaskReference,TaskText
      return parameters.detect{|item|item.id == key.parameter_id}   
    else
      return parameters.detect{|item|item.name == key.to_s}   
    end
 end
#
# get all the parameters in a specific role

 def role_parameters( role =nil )
    if !role.nil? 
        return parameters.reject{|p| p.role != role}
    else    
        return parameters
    end 
 end
 
#
# Get a matching context in the process
#
  def context(name)
    case name
    when Fixnum
      return self.contexts.detect{|item|item.id == name}   
    when ParameterContext
      return self.contexts.detect{|item|item.id == name.id}   
    when TaskContext
      return self.contexts.detect{|item|item.id == name.parameter_context_id}         
    else
      return self.contexts.detect{|item|item.label == name.to_s}   
    end
 end
 #
 # Return the first parameter context root defined in the process
 #
 def first_context
   self.roots[0]
 end  
##
# Create a new context in this process 
 def new_context( parent  = nil, name =nil)
    parameter_context = ParameterContext.new
    parameter_context.label =  name || "context"+contexts.size.to_s
    parameter_context.parent = parent if parent
    self.contexts << parameter_context
    return parameter_context
  end   

 # Create a new Implementation of the Process based on existing definition
 #
   def copy
       item = self.protocol.new_version(false)
       for old in self.roots
          item.copy_context(old)
       end 
       return item
   end   

##
# Copy a context and all its children from source to current instance
#  * source = a context in a process to copy
#  * parent = context in current process to use a parent
#  
  def copy_context(source , parent_context = nil)
     new_context = source.clone
     new_context.parent = parent_context
     new_context.id = nil
     new_context.process = self
     self.contexts << new_context
     new_context.save!
     for child in source.children
        new_context.children << copy_context(child,new_context)
     end
     for old in source.parameters
          parameter = old.clone
          parameter.id = nil
          parameter.parameter_context_id = new_context.id
          new_context.parameters << parameter
          self.parameters << parameter
     end
     return new_context
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
 
  def summary
     "Process [#{self.path(:assay)}] #{contexts.size} levels x #{parameters.size} params "
  end

  def to_liquid
    ProcessInstanceDrop.new self
  end
  
end

