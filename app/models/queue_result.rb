class QueueResult < ActiveRecord::Base

 def initialize
   super
   @readonly == true
 end
##
# The task this context belongs too
 belongs_to :task

 belongs_to :requested_by , :class_name=>'User', :foreign_key=>'requested_by_user_id'  

 belongs_to :assigned_to, :class_name=>'User', :foreign_key=>'assigned_to_user_id'  
##
# The Queue this request is linked too
# 
 belongs_to :queue, :class_name=>'StudyQueue', :foreign_key =>'study_queue_id'
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
# returns actual object
 def object
   return self.subject
 end 

 def name
   return self.subject.name
 end
 
 ##
 # Get the value for this result
 # 
 def value
   return self.data_value 
 end


end
