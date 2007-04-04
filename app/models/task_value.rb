# == Schema Information
# Schema version: 233
#
# Table name: task_values
#
#  id              :integer(11)   not null, primary key
#  task_context_id :integer(11)   
#  parameter_id    :integer(11)   
#  data_value      :float         
#  display_unit    :string(255)   
#  lock_version    :integer(11)   default(0), not null
#  created_by      :string(32)    default(), not null
#  created_at      :datetime      not null
#  updated_by      :string(32)    default(), not null
#  updated_at      :datetime      not null
#  task_id         :integer(11)   
#  storage_unit    :string(255)   
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
class TaskValue < ActiveRecord::Base
  include TaskItem 
   
  validates_presence_of :task
  validates_presence_of :context
  validates_presence_of :parameter
  validates_presence_of :data_value

##
# The task this context belongs too
 belongs_to :task

##
# context is provides a logical grouping of TaskItems which need to be seen as a whole to get the true
# meaning of the data (eg. Inhib+Dose+Sample is useful result!)
 belongs_to :context, :class_name=>'TaskContext', :foreign_key =>'task_context_id'

##
# The parameter definition the Item is linked back to from the Process Instance
# Added IC50(Output) etc to the basic value and defines the validation rules like must be numeric!
#  
 belongs_to :parameter
 
 ##
 #
 def value=(new_value)   
   self.data_value  = new_value
 end 

 def value
   return self.data_value 
 end
 
end
