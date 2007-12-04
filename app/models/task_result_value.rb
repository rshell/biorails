# == Schema Information
# Schema version: 281
#
# Table name: task_result_values
#
#  id                     :integer(11)   default(0), not null, primary key
#  row_no                 :integer(11)   not null
#  column_no              :integer(11)   
#  task_id                :integer(11)   
#  parameter_context_id   :integer(11)   
#  task_context_id        :integer(11)   
#  reference_parameter_id :integer(11)   
#  data_element_id        :integer(11)   
#  data_type              :string(255)   
#  data_id                :integer(11)   
#  subject                :string(255)   
#  parameter_id           :integer(11)   
#  protocol_version_id    :integer(11)   
#  label                  :string(255)   
#  row_label              :string(255)   
#  parameter_name         :string(62)    
#  data_value             :float         
#  created_by_USER_ID     :integer(11)   default(1), not null
#  created_at             :datetime      not null
#  updated_by_USER_ID     :integer(11)   default(1), not null
#  updated_at             :datetime      not null
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
# This is a simple read only view based model for reporting on numeric data in the database.
# It basically joins the text_values to a subject object reference in the same row for reporting
# For good performance the data_type,reference_parameter_id should be set in the driving query
# eg conditons => ['data_type=? and reference_parameter_id=?,'Compound',12] 
#  
class TaskResultValue < ActiveRecord::Base

 def initialize
   @readonly == true
 end

##
# The task this context belongs too
 belongs_to :task
##
# Direct link back to protocol version
# 
 belongs_to :process, :class_name=>'ProtocolVersion',:foreign_key=>'protocol_version_id'
##
# Direct link to parameter context
#
 belongs_to :definition, :class_name=>'ParameterContext',:foreign_key=>'parameter_context_id' 
##
# context is provides a logical grouping of TaskItems which need to be seen as a whole to get the true
# meaning of the data (eg. Inhib+Dose+Sample is useful result!)
 belongs_to :context, :class_name=>'TaskContext',:foreign_key=>'task_context_id'
##
# The parameter definition the Item is linked back to from the Process Instance
# Added IC50(Output) etc to the basic value and defines the validation rules like must be numeric!
#  
 belongs_to :parameter

 ##
# Convert Name to DataValue(id,Name) from DataElement
# 
 def lookup(name)
   if self.parameter && self.parameter.data_element
       self.parameter.data_element.lookup(name)
   else
     name    
   end
 end

##
# returns actual object
 def object
   unless @current_value      
      @current_value = lookup(self.subject)
   end
   return @current_value
 end 

 def name
   return self.parameter_name
 end
 
 ##
 # Get the value for this result
 # 
 def value
   return self.data_value 
 end

end
