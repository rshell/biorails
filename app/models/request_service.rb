# == Schema Information
# Schema version: 359
#
# Table name: request_services
#
#  id                   :integer(4)      not null, primary key
#  request_id           :integer(4)      not null
#  service_id           :integer(4)      not null
#  name                 :string(128)     default(""), not null
#  description          :string(1024)    default("")
#  expected_at          :datetime
#  started_at           :datetime
#  ended_at             :datetime
#  lock_version         :integer(4)      default(0), not null
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  priority_id          :integer(4)
#  updated_by_user_id   :integer(4)      default(1), not null
#  created_by_user_id   :integer(4)      default(1), not null
#  requested_by_user_id :integer(4)      default(1)
#  assigned_to_user_id  :integer(4)      default(1)
#  project_element_id   :integer(4)
#

# == Description
# This is part of a overall request as represents a single service which must be forfilled to 
# complete the overall request
#
# == Copyright
# 
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
#

class RequestService < ActiveRecord::Base
  
  has_priorities :priority_id

##
# This scheduled item is in turn broken down as follows
# 
  acts_as_scheduled :summary=>:items


  has_many_scheduled :items, :class_name => "QueueItem" ,:dependent => :destroy

  validates_uniqueness_of :name
  validates_presence_of :name 

  validates_presence_of :started_at
  validates_presence_of :expected_at
  validates_presence_of :request_id
  validates_presence_of :service_id 

  def validate
    validate_period
  end
 
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log

##
#Assay 
  belongs_to :request
#
# Owner project
#  
 acts_as_folder_linked  :request
##
# Results for this Item
#
  has_many :results, :class_name=>'QueueResult', :foreign_key=>'request_service_id'
##
#Current Request element is linked to a service provided
#
  belongs_to :queue, :class_name =>'AssayQueue', :foreign_key=>'service_id'

  belongs_to :requested_by , :class_name=>'User', :foreign_key=>'requested_by_user_id'  
  belongs_to :assigned_to , :class_name=>'User', :foreign_key=>'assigned_to_user_id'  

  #
  # Find objects matching the passed object
  #
  def self.matching(object =nil,options={})      
        with_scope :find => options  do
            case object
            when Project             
              find(:all, :include=>[:queue=>[:assay],:project_element=>[:state]],
                  :conditions=>["assays.project_id=?",object.id] )
            when AssayQueue     
              find(:all, 
                  :conditions=>["service_id= ?",object.id] )
            when User
              find(:all, :conditions=>["requested_by_user_id= ?",object.id] )
            when Request              
              find(:all, 
                   :conditions=>["request_id = ?",object.id] ) 
            when String             
              find(:all, 
                   :conditions=>["name like ?","#{object}%"] )
            end     
        end  
   end
##
# Submit a request to the queue
# 
  def submit
      logger.debug "submit #{self.name}"    
      self.assigned_to = queue.assigned_to
      self.queue.folder(self)
      n = 0
      for item  in request.items
         unless self.is_submitted(item.value)
           queue_item = self.queue.add(item, self)
           n +=1
           unless queue_item.save
             logger.warn "Failed to save QueueItem #{queue_item.errors.full_messages.to_sentence}"
           end
         end
      end
      self.save
      return n
  rescue Exception => ex
     logger.warn "failed to submit #{self.to_s}: #{ex.message}"
     return -1
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

 def update_state(params)
    self.priority_id = params[:priority_id]     if params[:priority_id]
    self.assigned_to_user_id = params[:user_id] if params[:user_id]
    self.comments << params[:comments]         if params[:comments]
    if params[:state_id].blank?
       self.save!
    else
       self.folder.set_state(params[:state_id])
    end
    self.reload
    items.each do |item|
       item.update_state(params)
    end
 end  
 
##
# Submit the request
#  
  def accept
      folder and folder.set_state(folder.state_flow.next_level(State::ACTIVE_LEVEL))
  end 
  
  def reject
      folder and folder.set_state(folder.state_flow.previous_level(0))
  end

  def complete
      folder and folder.set_state(folder.state_flow.next_level(State::FROZEN_LEVEL))
  end

  def num_active
    return items.inject(0){|sum, item| sum + (item.active? ? 1 : 0 )}
  end

  def num_finished
    return items.inject(0){|sum, item| sum + (item.finished? ? 1 : 0 )}
  end
  
  def percent_done
    if items.size>0
      100*( (num_active)/2.0 + num_finished)/items.size 
    else
      0
    end
  end

  def status_summary   
    "[ #{items.size} / #{num_active} / #{num_finished} ] #{percent_done}%"
  end
 

end
