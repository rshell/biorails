# == Schema Information
# Schema version: 280
#
# Table name: compound_results
#
#  id                    :integer(11)   default(0), not null, primary key
#  row_no                :integer(11)   not null
#  column_no             :integer(11)   
#  task_id               :integer(11)   
#  parameter_context_id  :integer(11)   
#  task_context_id       :integer(11)   
#  data_element_id       :integer(11)   
#  compound_parameter_id :integer(11)   
#  compound_id           :integer(11)   
#  compound_name         :string(255)   
#  protocol_version_id   :integer(11)   
#  label                 :string(255)   
#  row_label             :string(255)   
#  parameter_id          :integer(11)   
#  parameter_name        :string(62)    
#  data_value            :float         
#  created_by_user_id    :integer(11)   default(1), not null
#  created_at            :datetime      not null
#  updated_by_user_id    :integer(11)   default(1), not null
#  updated_at            :datetime      not null
#

##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class CompoundResult < ActiveRecord::Base
  
 def initialize
   @readonly == true
 end
##
# link back to compounds
#   
 belongs_to :compound

##
# The task this context belongs too
 belongs_to :task

##
# The parameter definition for the usage of the compound in the results (subject,standard,control  etc)
#  
 belongs_to :usage , :class_name =>'Parameter',:foreign_key=>'compound_parameter_id'

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
# returns actual object
 def object

   return self.compound
 end 

 def name
   return self.compound.name
 end
 
 ##
 # Get the value for this result
 # 
 def value
   return self.data_value 
 end

 
end
