# == Schema Information
# Schema version: 281
#
# Table name: queue_items
#
#  id                   :integer(11)   not null, primary key
#  name                 :string(255)   
#  comments             :text          
#  study_queue_id       :integer(11)   
#  experiment_id        :integer(11)   
#  task_id              :integer(11)   
#  study_parameter_id   :integer(11)   
#  data_type            :string(255)   
#  data_id              :integer(11)   
#  data_name            :string(255)   
#  expected_at          :datetime      
#  started_at           :datetime      
#  ended_at             :datetime      
#  lock_version         :integer(11)   default(0), not null
#  created_at           :datetime      not null
#  updated_at           :datetime      not null
#  request_service_id   :integer(11)   
#  status_id            :integer(11)   default(0), not null
#  priority_id          :integer(11)   
#  updated_by_user_id   :integer(11)   default(1), not null
#  created_by_user_id   :integer(11)   default(1), not null
#  requested_by_user_id :integer(11)   default(1)
#  assigned_to_user_id  :integer(11)   default(1)
#

##
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

##
# Item in a queue to allow difference types of data to be queued by 3rd parties for processing
# in tasks.
# 
class QueueItem < ActiveRecord::Base

  include CurrentPriority
  include CatalogueReference

  acts_as_scheduled 

##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log

  validates_presence_of   :study_parameter_id
  
  validates_presence_of   :data_type
  validates_presence_of   :data_id
  validates_presence_of   :data_name

 belongs_to :requested_by , :class_name=>'User', :foreign_key=>'requested_by_user_id'  

 belongs_to :assigned_to, :class_name=>'User', :foreign_key=>'assigned_to_user_id'  
##
# Results for this Item
#
 has_many :results, :class_name=>'QueueResult', :foreign_key=>'queue_item_id'
##
# The Queue this request is linked too
# 
 belongs_to :queue, :class_name=>'StudyQueue', :foreign_key =>'study_queue_id'
##
#Current Request element is linked to a service provided
#
 belongs_to :service, :class_name =>'RequestService', :foreign_key=>'request_service_id' 
##
# The task this request is currently active within
 belongs_to :task 
##
# The experiment this request is planned to be forfilled in
 belongs_to :experiment
##
# The study parameter definition the Item is linked back.
# Eg Compounds or Plates
#  
 belongs_to :parameter, :class_name =>'StudyParameter',:foreign_key=>'study_parameter_id'
##
# get the request linked to item
#
 def request
   request_service.request if request_service
 end

 def data_element
   queue.data_element if queue
 end
 
 def update_state(params)
    self.state_id = params[:status_id].to_i     if params[:status_id]
    self.priority_id = params[:priority_id]     if params[:priority_id]
    self.assigned_to_user_id = params[:user_id] if params[:user_id]
    self.comments << params[:comments]          if params[:comments]
 end

##
#Build a list of test contexts associc (the analysts views) 
#  
  def task_contexts
    sql =<<-SQL 
      select * from task_contexts c,task_references r 
      where c.id=r.task_context_id 
      and r.data_type=? and r.data_id=?
      order by c.parameter_context_id,c.task_id
SQL
    return TaskContext.find_by_sql([sql,self.object.class.to_s,self.object.id])
  end

end
