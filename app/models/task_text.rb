# == Schema Information
# Schema version: 359
#
# Table name: task_texts
#
#  id                 :integer(4)      not null, primary key
#  task_context_id    :integer(4)      not null
#  parameter_id       :integer(4)      not null
#  data_content       :string(1000)
#  lock_version       :integer(4)      default(0), not null
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  task_id            :integer(4)      not null
#  updated_by_user_id :integer(4)      default(1), not null
#  created_by_user_id :integer(4)      default(1), not null
#

# == Description
# This is handles qualitive textual result values as text strings.
# 
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
# 
class TaskText < ActiveRecord::Base
  acts_as_task_item
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
   return self.parameter.parse(data_content)
 end

 def value=(new_value)
   self.data_content = self.parameter.format(new_value) 
 end
 #
 # convert content text to Unit (numeric type)
 #
 def to_unit
   Unit.new(data_content.to_s) 
 rescue Exception => ex
    nil
 end
 #
 # Convert to formatted string
 #
 def to_s
   return self.data_content if data_content 
   self.parameter.default_value.to_s if self.parameter
 end  
  
end
