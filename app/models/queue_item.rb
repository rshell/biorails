# == Schema Information
# Schema version: 359
#
# Table name: queue_items
#
#  id                   :integer(4)      not null, primary key
#  name                 :string(255)
#  comments             :string(1024)    default(""), not null
#  assay_queue_id       :integer(4)
#  experiment_id        :integer(4)
#  task_id              :integer(4)
#  assay_parameter_id   :integer(4)
#  data_type            :string(255)
#  data_id              :integer(4)
#  data_name            :string(255)
#  expected_at          :datetime
#  started_at           :datetime
#  ended_at             :datetime
#  lock_version         :integer(4)      default(0), not null
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  request_service_id   :integer(4)
#  priority_id          :integer(4)
#  updated_by_user_id   :integer(4)      default(1), not null
#  created_by_user_id   :integer(4)      default(1), not null
#  requested_by_user_id :integer(4)      default(1)
#  assigned_to_user_id  :integer(4)      default(1)
#

# == Description
# Item in a queue to allow difference types of data to be queued by 3rd parties for processing
# in tasks.
# 
# == Copyright
# 
# Copyright © 2006 Andrew Lemon, Alces Ltd All Rights Reserved
# See license agreement for additional rights
#

class QueueItem < ActiveRecord::Base

  has_priorities :priority_id

  acts_as_catalogue_reference

#
# Owner project
#
  acts_as_folder_linked  :service
 
  acts_as_scheduled


##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log

  validates_presence_of   :assay_parameter_id
  
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
 belongs_to :queue, :class_name=>'AssayQueue', :foreign_key =>'assay_queue_id'
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
# The assay parameter definition the Item is linked back.
# Eg Compounds or Plates
#  
 belongs_to :parameter, :class_name =>'AssayParameter',:foreign_key=>'assay_parameter_id'
##
# get the request linked to item
#
 def request
   service.request if service
 end

 def data_element
   queue.data_element if queue
 end
 
 def update_state(params)
    self.priority_id = params[:priority_id]     if params[:priority_id]
    self.assigned_to_user_id = params[:user_id] if params[:user_id]
    self.comments << params[:comments]          if params[:comments]
    if params[:state_id]
      self.folder.set_state(params[:state_id].to_i)
    else
      self.save!
    end
    self.reload
 end

  def used_by_task_reference(task_item)
    if self.active? and (self.task_id.nil? or self.task_id==task_item.task_id)
      unless task_item.value 
         task_item.value = self.value
         task_item.save
      end  
      if task_item.value == self.value
         self.task_id = task_item.task_id
         self.experiment_id = task_item.task.experiment_id
         self.state_id = task.state_id
         self.save
      else
        logger.error "Cant assign #{task_item.value} != #{self.value}"
        return nil
      end     
    end
  end  

end
