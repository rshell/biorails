# == Schema Information
# Schema version: 239
#
# Table name: request_services
#
#  id                 :integer(11)   not null, primary key
#  request_id         :integer(11)   not null
#  service_id         :integer(11)   not null
#  name               :string(128)   default(), not null
#  description        :text          
#  requested_by       :string(60)    
#  expected_at      :datetime      
#  assigned_to        :string(60)    
#  accepted_at        :datetime      
#  completed_at       :datetime      
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  status_id          :integer(11)   
#  priority_id        :integer(11)   
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#


##
# This is part of a overall request as represents a single service which must be forfilled to 
# complete the overall request
##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 
class RequestService < ActiveRecord::Base
  
  include  CurrentPriority

##
# This scheduled item is in turn broken down as follows
# 
  acts_as_scheduled :summary_of=>:items

  has_many_scheduled :items, :class_name => "QueueItem" 

 
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log

##
#Study 
 belongs_to :request

##
#Current Request element is linked to a service provided
#
  belongs_to :queue, :class_name =>'StudyQueue', :foreign_key=>'service_id'

  belongs_to :request_by , :class_name=>'User', :foreign_key=>'requested_by_user_id'  
  belongs_to :assigned_to , :class_name=>'User', :foreign_key=>'assigned_to_user_id'  

  
##
# Submit a request to the queue
# 
  def submit
      logger.debug "submit #{self.name}"
      self.status = CurrentStatus::NEW      
      self.assigned_to = queue.assigned_to
      for item  in request.items
         unless is_submitted(item.value)
           queue_item = self.queue.items.add(item,self)
           queue_item.save
           puts queue_item.to_yaml
         end
      end
      self.save
      items.size
  rescue Exception => ex
     logger.warn "failed to submit #{self.to_s}: #{ex.message}"
      
  end 

##
# test if a value is already submitted 
  def is_submitted(value)
    items.any?{|item|item.value == value}
  end

  def priority_id=(new_id)
    self['priority_id']=new_id
    for item in items
      item.priority_id = new_id
    end
  end
   
##
# Submit the request
#  
  def accept
      self.status = Alces::ScheduledItem::ACCEPTED
  end 
  
  def reject
      self.status =  Alces::ScheduledItem::REJECTED
  end

  def complete
      self.status =  Alces::ScheduledItem::COMPLETED
  end

##
# Change the status of the value and all children
#   
  def status=(value)
    if is_allowed_state(value)
      self.current_state == value
      for item  in self.items
          item.current_state = value
      end
    end
  end
  
  def status   
    if items.any?{|item|item.is_active}
      self.status_id = CurrentStatus::PROCESSING
    elsif items.any?{|item|item.is_finished}
      self.status_id = CurrentStatus::COMPLETED
    else
      self.status_id = CurrentStatus::NEW
    end
    current_state
  end

  def num_active
    return items.inject(0){|sum, item| sum + (item.is_active ? 1 : 0 )}
  end

  def num_finished
    return items.inject(0){|sum, item| sum + (item.is_finished ? 1 : 0 )}
  end
  
  def percent_done
    if items.size>0
      ((100*num_active)/2 + 100*num_finished)/items.size 
    else
      0
    end
  end

  def status_summary   
    "[ #{items.size} / #{num_active} / #{num_finished} ] #{percent_done}%"
  end
 

end
