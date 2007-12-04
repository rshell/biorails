# == Schema Information
# Schema version: 281
#
# Table name: task_texts
#
#  id                 :integer(11)   not null, primary key
#  task_context_id    :integer(11)   
#  parameter_id       :integer(11)   
#  data_content       :text          
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  task_id            :integer(11)   
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
class TaskText < ActiveRecord::Base
  include TaskItem 
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log

  validates_presence_of :task
  validates_presence_of :context
  validates_presence_of :parameter
  validates_presence_of :data_content

##
# The task this context belongs too
 belongs_to :task

##
# context is provides a logical grouping of TaskItems which need to be seen as a whole to get the true
# meaning of the data (eg. Inhib+Dose+Sample is useful result!)
 belongs_to :context, :class_name=>'TaskContext',:foreign_key =>'task_context_id'

##
# The parameter definition the Item is linked back to from the Process Instance
# Added IC50(Output) etc to the basic value and defines the validation rules like must be numeric!
#  
 belongs_to :parameter

 def value
   return data_content 
 end

 def value=(value)
   self.data_content = value if self.data_content != value 
 end
 
 def to_unit
   Unit.new(data_content.to_s) 
 end
 
 def to_s
    formatter = self.parameter.data_format.format_sprintf if self.parameter and self.parameter.data_format
    if formatter && formatter.size>0 
       return sprintf(formatter,data_content.to_s)
    end
    return data_content.to_s
 end  
  
end
