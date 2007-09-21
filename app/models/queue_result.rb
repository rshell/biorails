# == Schema Information
# Schema version: 280
#
# Table name: queue_results
#
#  id                     :integer(11)   default(0), not null, primary key
#  row_no                 :integer(11)   default(0), not null
#  column_no              :integer(11)   
#  task_id                :integer(11)   
#  queue_item_id          :integer(11)   default(0), not null
#  request_service_id     :integer(11)   
#  study_queue_id         :integer(11)   
#  requested_by_user_id   :integer(11)   
#  assigned_to_user_id    :integer(11)   
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
#  data_value             :binary        
#  created_by_user_id     :integer(11)   default(0), not null
#  created_at             :datetime      not null
#  updated_by_user_id     :integer(11)   default(0), not null
#  updated_at             :datetime      not null
#

class QueueResult < ActiveRecord::Base

 def initialize
   super
   @readonly == true
 end
 
#
# Results for a request
#
 def self.find_for(item)
   case item
   when QueueItem
     return QueueResult.find(:all,
                    :include=>:service,
                    :order=>['request_services.name,queue_results.subject,queue_results.parameter_name'],
                    :conditions=>['request_services.id=? and queue_results.data_id=?',item.request_service_id,item.data_id])
   when StudyQueue
     return QueueResult.find(:all,
                    :include=>:service,
                    :order=>['request_services.name,queue_results.subject,queue_results.parameter_name'],
                    :conditions=>['queue_results.study_queue_id=?',item.id])
   when RequestService
     return QueueResult.find(:all,
                    :include=>:service,
                    :order=>['request_services.name,queue_results.subject,queue_results.parameter_name'],
                    :conditions=>['request_services.id=?',item.id])
   when Request
     return QueueResult.find(:all,
                    :include=>:service,
                    :order=>['request_services.name,queue_results.subject,queue_results.parameter_name'],
                    :conditions=>['request_services.request_id=?',item.id])
   when String,Fixnum
     return QueueResult.find(:all,
                    :include=>:service,
                    :order=>['request_services.name,queue_results.subject,queue_results.parameter_name'],
                    :conditions=>['request_services.request_id=?',item])
   else
     return QueueResult.find(:all,
                    :include=>:service,
                    :order=>['request_services.name'],
                    :conditions=>['queue_results.data_id=?',item.id])
     
   end   
 end
#
# Results for a specific item in a queue
#
 def self.find_for_request_subject(request_id, subject)
   subject_id = nil
   case subject
   when QueueItem,ListItem
     subject_id = subject.data_id
   when String,Fixnum
     subject_id = subject
   else
     subject_id = subject.id
   end
   return QueueResult.find(:all,
                    :include=>:service,
                    :order=>['request_services.name'],
                    :conditions=>['request_services.request_id=? and queue_results.data_id=?',request_id,subject_id])
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
