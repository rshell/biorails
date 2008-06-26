# == Schema Information
# Schema version: 306
#
# Table name: requests
#
#  id                   :integer(11)   not null, primary key
#  name                 :string(128)   default(), not null
#  description          :string(1024)  default(), not null
#  expected_at          :datetime      
#  lock_version         :integer(11)   default(0), not null
#  created_at           :datetime      not null
#  updated_at           :datetime      not null
#  list_id              :integer(11)   
#  data_element_id      :integer(11)   
#  status_id            :integer(11)   default(0), not null
#  priority_id          :integer(11)   
#  project_id           :integer(11)   
#  updated_by_user_id   :integer(11)   default(0), not null
#  created_by_user_id   :integer(11)   default(0), not null
#  requested_by_user_id :integer(11)   default(0)
#  started_at           :datetime      
#  ended_at             :datetime      
#  team_id              :integer(11)   default(0), not null
#

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
#
# Basic rules for a Named Object
#
   acts_as_dictionary :name 
#
# Allow standard priority levels
#
   has_priorities :priority_id 
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
#
# Allow free text indexing of the name and description into common class
# 
  acts_as_ferret  :fields => {:name =>{:boost=>2,:store=>:yes} , 
                              :description=>{:store=>:yes,:boost=>0}},
                   :default_field => [:name],           
                   :single_index => true, 
                   :store_class_name => true 
  
##
# Request is a summary of list of scheduled request for services
# 
  acts_as_scheduled :summary=>:services
#
#  The request will exist as a scheduled item built out of a number of requested services 
#
  has_many_scheduled :services,  :class_name=>'RequestService',:dependent => :destroy
#
# Generic rules for a name and description to be present
#
  validates_uniqueness_of :name

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :started_at 
  validates_presence_of :data_element_id
  validates_presence_of :project_id


###
#Owner project
#  
  belongs_to :project  
#
# access control managed via team
# 
  access_control_via  :team
#
# Requested at a user
#
  belongs_to :requested_by , :class_name=>'User', :foreign_key=>'requested_by_user_id'  
##
#  has many project elements associated with it
#  
  has_many :elements, :class_name=>'ProjectElement' ,:as => :reference,:dependent => :destroy
#
# All requests related to specific data element type like a 'Compound' or 'Sample'
#
  belongs_to :data_element
#
# A request has a list of items submitted to it, this is managed as a list of items of a specific data_ement type
#   has_one :list, :class_name => 'RequestList', :foreign_key => 'list_id'

   belongs_to :list , :dependent => :destroy
#
# Intercept database saves
#  * correct folder names on update
#  * delete folder on self delete
#  * make sure team assigned on create
#
   def before_update
      ref = self.folder
      if ref.name !=self.name
        ref.name = self.name
        ref.save!
      end
  end

  def before_destroy
     self.folder.destroy
  end

  def before_create 
    self.team_id = self.project.team_id if self.project    
  end
#
# Constructor uses current values for User,project and team in creation of a new Request
# These can be overiden as parameters (:user_id=> ,:project_id => , team_id => )
#
  def initialize(params= {})
      super(params)      
      self.status_id    ||= 0
      self.started_at   = Time.new
      self.requested_by_user_id = User.current.id
      self.project_id      = Project.current.id
      self.team_id         = Team.current.id
      self.data_element_id ||= DataElement.find(:first).id 
  end
  
##
# Create a List and its linked RequestList   
  def self.create(params)
     user_request = Request.new(params)
     user_request.list = RequestList.create(:name=>user_request.name,:data_element_id=>user_request.data_element_id)
     if user_request.list
        user_request.save
     end
     return user_request
  end
  
#
# Get the folder for this assay
#
  def folder(item=nil)
    folder = self.project.folder(self)
    if item
      return folder.folder(item)
    else
      return folder
    end
  end   
##
# Transform items into a hash of hashs for a table of queue_item cell with item.name row ids
#   
  def items_by_service     
     @grid = {}         
     services.each do |service|
        service.items.each do |item|
          if item.data_name and service.name          
            @grid[item.data_name] ||={} 
            @grid[item.data_name][service.name]=item.status  
          end          
        end
     end
     return @grid
  end
  #
  # status
  #
  def item_status(object_name,service_name)
    @grid ||= items_by_service  
    return 'not known' unless @grid[object_name]    
    return 'not submitted' unless @grid[object_name][service_name] 
    @grid[object_name][service_name]     
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
             ti.created_by_user_id,
             ti.created_at,
             ti.updated_by_user_id,
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
      and  li.list_id = #{list.id}
SQL
    return TaskValue.find_by_sql(sql)
  end

##
# Add  service to list linked to this request  
# 
  def add_service(queue)
    unless has_service(queue)
      request_service = RequestService.new
      request_service.request = self
      request_service.queue = queue
      request_service.name = "#{self.name}-#{queue.id}" 
      request_service.started_at = self.started_at
      request_service.expected_at = self.expected_at
      request_service.requested_by_user_id = self.requested_by_user_id
      request_service.assigned_to_user_id = queue.assigned_to_user_id
      self.services << request_service
      request_service.save
      return request_service
    end
  rescue Exception => ex
    logger.error "Failed to add Service #{ex.message}"    
    return nil
  end

##
# has this queue already been added to the request
# 
  def has_service(queue)
    self.services.detect{|item|item.queue == queue}
  end
  
##
# Add a item to the list of objects in the request 
#  
  def add_item(object)
    logger.info "add_items( #{object} )"
    RequestList.transaction do
      unless self.list
        logger.warn "add_items to new list #{object}"
        @list = RequestList.find_by_name(self.name) || RequestList.new
        #@list.request = self
        @list.name = self.name
        @list.description = "Request #{self.name}"
        @list.data_element = self.data_element
        @list.save
        self.list = @list
      end  
      self.list.add(object)   
    end 
  end
  
##
# Remove a item from the request  
# 
  def remove_item(name)   
    for service in services
       item = QueueItem.find(:first,:conditions=>['request_service_id = ? and data_name = ?',service.id,name])
       if item and item.is_status([0,1,2,5,-1,-2])
          item.destroy 
       end
    end
    self.items.find_by_data_name(name).destroy    
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
     where exists (select 1 from assay_parameters p  
        inner join assay_queues q on q.assay_parameter_id = p.id
        where p.data_element_id = e.id)
SQL
     @allowed_elements ||= DataElement.find_by_sql(sql)
  end 
#
# its is possible to create a runnable request
#
  def runnable?
    ((self.allowed_elements.size >0) and (self.allowed_services.size > 0))
  end
  
  def self.runnable?
    return AssayQueue.find(:first)
  end
##
# List of allowed service types for a set data_element_id
# 
  def allowed_services
     sql = <<SQL
      select q.* 
      from assay_queues q 
      inner join assay_parameters p on q.assay_parameter_id = p.id  
      inner join data_elements e on p.data_element_id = e.id  
      where e.id = ?
SQL
     @allowed_services ||= AssayQueue.find_by_sql([sql,self.data_element_id])  
  end
  

  
end
