##
# Module to handle status changes with the lifecycle of a status of a object.
# 
# This expects the following attribute in the base class
#  status
#  accepted_at
#  completed_at
# 
  module CurrentStatus
##
# Allowed status values 
#  
  NEW       =0
  ACCEPTED  =1
  WAITING   =2
  PROCESSING=3
  VALIDATION=4
  COMPLETED =5
  REJECTED  =-1
  ABORTED   =-2
###
# Status to human readable version for display
# 
  STATES = {nil =>'undefined',
            ABORTED=>'aborted',
            REJECTED =>'rejected',
            NEW =>'new',
            ACCEPTED =>'accepted',
            WAITING =>'waiting',
            PROCESSING =>'processing',
            VALIDATION =>'validation',
            COMPLETED =>'completed'}
##
# This the the table of allowed state changes for the system
#   
  STATE_CHANGES = {
            nil        =>[NEW],
            NEW        =>[NEW,ACCEPTED,REJECTED,WAITING,PROCESSING,VALIDATION,COMPLETED],
            ACCEPTED   =>[ACCEPTED,WAITING,PROCESSING,VALIDATION,COMPLETED,REJECTED,ABORTED],
            WAITING    =>[WAITING,PROCESSING,VALIDATION,COMPLETED,ABORTED],
            PROCESSING =>[WAITING,PROCESSING,VALIDATION,COMPLETED,ABORTED],
            VALIDATION =>[WAITING,PROCESSING,VALIDATION,COMPLETED,ABORTED],
            COMPLETED  =>[COMPLETED,REJECTED],
            ABORTED    =>[ABORTED,NEW],
            REJECTED   =>[REJECTED,NEW]
            }  

  NEW_STATES = [nil,NEW]
  PAUSED_STATES = [NEW,ACCEPTED,WAITING]
  ACTIVE_STATES = [ACCEPTED,WAITING,PROCESSING,VALIDATION]
  FINISHED_STATES= [REJECTED,ABORTED,COMPLETED]
  FAILED_STATES = [REJECTED,ABORTED]

##
# Get the status of the object  
 def current_state
   return CurrentStatus::STATES[self.status_id]
 end

 def current_state_id
    self.status_id
 end

##
# Test if state change is valid
# 
 def is_allowed_state(new_id)
    STATE_CHANGES[self.status_id].include?(new_id.to_i)
 end

 
 def current_state_id=(new_id)
    if is_allowed_state(new_id) and new_id != self.status_id 
      self.updated_at = DateTime.now if self.respond_to?(:updated_at)
      self.status_id = new_id
      date_logger = "#{STATES[self.status_id].downcase}_at="
      self.send(date_logger,DateTime.now) if self.respond_to?(date_logger)
      if is_finished
         self.completed_at = DateTime.now if self.respond_to?(:completed_at)
      end
    end
    self.status_id
 end
 
##
# Change the status of the object
 def current_state=(value)
    new_id = nil
    case value
    when Fixnum
      new_id = value
    when String
      new_id =  CurrentStatus::STATES.invert[value]  
    else
      new_id == value.id
    end
    status_id = new_id
    return  CurrentStatus::STATES[self.status_id]
 end
 
 
##
# Get a list of  
 def allowed_status_list
   list = []
   for item in STATE_CHANGES[self.status_id]
     list << [STATES[item],item]
   end
   return list
 end

##
# Is the object in this state
 def is_status(value)
    case value
    when Fixnum
      return self.status_id == value
    when String
      return current_state == value
    when Array
      return value.include?(self.status_id)  
    else
      return self.status_id == value.id
    end
 end
 


##
# Test whether this recording is activily being worked on 
 def is_active
   return ACTIVE_STATES.include?(self.status_id)
 end

##
# Test whether work is completed with this object
 def is_finished
   return FINISHED_STATES.include?(self.status_id)
 end

 def is_completed
   return COMPLETED == self.status_id
 end
###
# Test whether the object is new 
 def is_new
   return NEW_STATES.include?(self.status_id)
 end
##
# Test whether the object is waiting for something 
 def is_waiting
   return PAUSED_STATES.include?(self.status_id)
 end
##
# Test whether the object has failed 
# 
 def has_failed
   return FAILED_STATES.include?(self.status_id)   
 end

##
#get the default period of time for a task
#
 def period 
   if ended_at > started_at 
      ended_at - started_at 
   else
      1.day
   end
 end 
##
# Setup Initial status value
  def initial
     if !is_finished 
       self.status_id = CurrentStatus::NEW
       self.accepted_at = nil
       self.completed_at = nil
     end
  end 

  
  end