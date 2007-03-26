##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 
##
# This is the high level go fore and submit a list of stuff to a list of services.
# The request can be seen as a 3 level item as follows :-
# 
#   * Level 0: The Request
#   * Level 1: The Request for a service
#   * Level 2: The Stuff to submit to the service
# 
# At present a list of items in the request is not kept separate from the list of queued items
# in services. This may be needed as a enhancement for resolution of multiple request to a 
#  single action in a service. At present business rule of multiple request are manually handled is used instead.
# 
# 

class Request < ActiveRecord::Base
  included Named
  include  CurrentStatus
  include  CurrentPriority
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description
  validates_uniqueness_of :name
##
# Study Has a number of items associated with the request
# 
  has_many :services, :class_name=>'RequestService'
  
  belongs_to :data_element
  
  belongs_to :list , :dependent => false
  
##
# Create a List and its linked RequestList   
  def self.create(params)
     list = RequestList.create(params)
     request = list.request if list
     if request
       request.status_id = CurrentStatus::NEW
       request.priority_id = CurrentPriority::LOW
       return request
     end
     return nil
  end
##
# Transform items into a hash of hashs for a table of queue_item cell with item.name row ids
#   
  def items_by_service
     @items_status = {}
     for item in self.items
       @items_status[item.data_name] = {}
     end           
     for request_service in self.services
        for item in request_service.items
          @items_status[item.data_name][request_service.name] = item          
        end
     end
     return @items_status
  end
  
##
# get the array of items associated with this request  
  def items
     self.list = List.new unless list
     return self.list.items
  end

###
# Submit any new items to the all the services
# 
  def submit
    for service in self.services
      service.submit
    end
  end

##
# get the status if the request
# 
  def status
    self.current_state
  end
  
##
# request the status of the request and all contained services
#   
  def status=(value)
    if is_allowed_state(value)
      self.current_state == value
      for item  in self.services
          item.status = value
      end
    end
  end
##
#  Get any numeric results linked to this list of materials
#  
  def numeric_results
  sql = <<SQL
       select  ti.id id,
             ti.task_id,
             ti.task_context_id,
             ti.parameter_id,
             ti.data_value,
             ti.display_unit,
             ti.storage_unit,
             ti.lock_version,
             ti.created_by,
             ti.created_at,
             ti.updated_by,
             ti.updated_at,
             t.name task_name,
             tc.row_no,
             tc.label row_label,
             pc.protocol_version_id,
             pc.label,
             p.name parameter_name,
             p.column_no,
             p.parameter_context_id,
             li.list_id,
             tr.data_element_id,
             tr.parameter_id item_parameter_id,
             tr.data_id,
             tr.data_name,
             tr.data_type   
      from parameter_contexts pc,
           parameters p,
           tasks t,
           task_contexts tc,
           task_references tr,
           list_items li,
           task_values ti
      where  tc.id = tr.task_context_id 
      and   ti.task_context_id = tc.id 
      and   ti.task_id = t.id
      and   p.id = ti.parameter_id
      and   pc.id = tc.parameter_context_id 
      and  tr.data_type= li.data_type
      and  tr.data_id = li.data_id
      and  li.list_id = ?
SQL
    return TaskValue.find_by_sql([sql,list.id])
  end

##
# Add  service to list linked to this request  
# 
  def add_service(queue)
    unless has_service(queue)
      request_service = RequestService.new
      request_service.request = self
      request_service.queue = queue
      request_service.name = "RS-#{self.id}-#{queue.id}"    
      request_service.requested_for = self.requested_for
      request_service.requested_by = self.requested_by
      services << request_service
    end
  end

##
# has this queue already been added to the request
# 
  def has_service(queue)
    services.detect{|item|item.queue == queue}
  end
  
##
# Add a item to the list of objects in the request 
#  
  def add_item(object)
    unless self.list
      logger.warn "add_items to new list #{object}"
      @list = RequestList.new
      #@list.request = self
      @list.name = self.name
      @list.description = "Request #{self.name}"
      @list.data_element = self.data_element
      @list.save
      self.list = @list

    end  
    list.add(object)    
  end
  
##
# Remove a item from the request  
# 
  def remove_item(name)   
    for service in services
       item = QueueItem.find(:first,:conditions=>['request_service_id = ? and data_name = ?',service.id,name])
       if item and (item.is_waiting or item.has_failed)
          item.destroy 
       end
    end
  end

##
# Reset the priority of all members
# 
  def priority_id=(new_id)
    self['priority_id']=new_id
    for service in services
      service.priority_id = new_id
    end
  end
##
#  List of allowed DataElement types for requests system wide  
#  
  def allowed_elements
     sql = <<SQL
     select e.* from data_elements e 
     where exists (select 1 from study_parameters p  
        inner join study_queues q on q.study_parameter_id = p.id
        where p.data_element_id = e.id)
SQL
     DataElement.find_by_sql(sql)
  end 

##
# List of allowed service types for a set data_element_id
# 
  def allowed_services
     sql = <<SQL
      select q.* 
      from study_queues q 
      inner join study_parameters p on q.study_parameter_id = p.id  
      inner join data_elements e on p.data_element_id = e.id  
      where e.id = ?
SQL
     StudyQueue.find_by_sql([sql,self.data_element_id])  
  end
  

  
end
