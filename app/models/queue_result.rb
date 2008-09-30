# == Schema Information
# Schema version: 359
#
# Table name: queue_results
#
#  id                     :integer(4)      default(0), not null, primary key
#  row_no                 :integer(4)      default(0), not null
#  column_no              :integer(4)
#  task_id                :integer(4)      default(0), not null
#  queue_item_id          :integer(4)      default(0), not null
#  request_service_id     :integer(4)
#  assay_queue_id         :integer(4)
#  requested_by_user_id   :integer(4)
#  assigned_to_user_id    :integer(4)
#  parameter_context_id   :integer(4)      default(0), not null
#  task_context_id        :integer(4)      default(0), not null
#  reference_parameter_id :integer(4)      default(0), not null
#  data_element_id        :integer(4)
#  data_type              :string(255)     default(""), not null
#  data_id                :integer(4)      default(0), not null
#  subject                :string(255)
#  parameter_id           :integer(4)      default(0), not null
#  protocol_version_id    :integer(4)      default(0), not null
#  label                  :string(255)
#  row_label              :string(255)
#  parameter_name         :string(62)      default(""), not null
#  data_value             :binary(21474836
#  created_by_user_id     :integer(4)      default(0), not null
#  created_at             :datetime        not null
#  updated_by_user_id     :integer(4)      default(0), not null
#  updated_at             :datetime        not null
#

# == Description
# Base Class for external analysis
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#
class QueueResult < ActiveRecord::Base

 def initialize(*args)
   super(*args)
   @readonly = true
 end
 
##
# The task this context belongs too
 belongs_to :task

 belongs_to :requested_by , :class_name=>'User', :foreign_key=>'requested_by_user_id'  

 belongs_to :assigned_to, :class_name=>'User', :foreign_key=>'assigned_to_user_id'  
##
# The Queue this request is linked too
# 
 belongs_to :queue, :class_name=>'AssayQueue', :foreign_key =>'assay_queue_id'
##
#Current Request element is linked to a service provided
#
 belongs_to :service, :class_name =>'RequestService', :foreign_key=>'request_service_id'
##
# The parameter definition for the usage of the compound in the results (subject,standard,control  etc)
#  
 belongs_to :usage , :class_name =>'Parameter',:foreign_key=>'reference_parameter_id'
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
 # Get the value for this result
 # 
 def value
   return self.data_value 
 end


end
