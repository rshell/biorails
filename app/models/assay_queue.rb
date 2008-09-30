# == Schema Information
# Schema version: 359
#
# Table name: assay_queues
#
#  id                  :integer(4)      not null, primary key
#  name                :string(128)     default(""), not null
#  description         :string(1024)    default(""), not null
#  assay_id            :integer(4)
#  assay_stage_id      :integer(4)
#  assay_parameter_id  :integer(4)
#  assay_protocol_id   :integer(4)
#  status              :string(255)     default("new"), not null
#  priority            :string(255)     default("normal"), not null
#  lock_version        :integer(4)      default(0), not null
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#  updated_by_user_id  :integer(4)      default(1), not null
#  created_by_user_id  :integer(4)      default(1), not null
#  assigned_to_user_id :integer(4)      default(1)
#  project_element_id  :integer(4)
#

##
# == Description
# 
# This is queue of work associated with the assay. This is separated from processes as 
# in really defined as start or end link in a process.
# 
# Queues of simple named items accepting a single type of data for processing in the assay.
# This is governed in the same major as with fields on the process data entry grids
# 
# == Copyright
#
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
# 

class AssayQueue < ActiveRecord::Base
  
   acts_as_dictionary :name 
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
  acts_as_ferret  :fields => {:name =>{:boost=>2,:store=>:yes} , 
                              :description=>{:store=>:yes,:boost=>0},
                               }, 
                   :default_field => [:name],           
                   :single_index => true, 
                   :store_class_name => true 
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description

  validates_uniqueness_of :name,:scope=>'assay_id'
  validates_presence_of   :assay_id
  validates_presence_of   :assay_stage_id
  validates_presence_of   :assay_parameter_id
##
# Results for this Item
#
 has_many :results, :class_name=>'QueueResult', :foreign_key=>'assay_queue_id'
##
#Assay 
 belongs_to :assay
#
# Owner project
#  
acts_as_folder_linked  :assay,:under=>'queues'
  
##
#Current process instance associated with the protocol
 belongs_to :protocol, :class_name =>'AssayProtocol',:foreign_key=>'assay_protocol_id'
 
##
# Data accepted into the queue is linked to a type of Assay Parameter
# to defined the source and data type. For example may well link back to compounds with a lookup
# defined in data_elements.
# 
 belongs_to :parameter, :class_name => 'AssayParameter',:foreign_key=>'assay_parameter_id'

##
# Stage the protocol is linked into 
 belongs_to :stage,  :class_name =>'AssayStage',:foreign_key=>'assay_stage_id'

 belongs_to :assigned_to, :class_name=>'User', :foreign_key=>'assigned_to_user_id'   
##
# Assay Has a number of queues associated with it
# 
 has_many_scheduled :items, :class_name => "QueueItem",:dependent => :destroy 
      
##
#Link to service request for work to be done
#  
  has_many_scheduled :requests, :class_name=> "RequestService",:foreign_key=>'service_id',:dependent => :destroy

  def initialize(params= {})
      super(params)      
      self.assigned_to = User.current
  end
##
# Add a object to the queue
#   
 def add(object,request_service=nil)
     item = QueueItem.new({ 
        :assigned_to => self.assigned_to,
        :assay_parameter_id => self.assay_parameter_id,
        :data_type => object.data_type,
        :data_id => object.data_id,
        :data_name => object.data_name,
        :name => object.data_name})
     item.status_id = 0
     if  request_service
         item.request_service_id   = request_service.id
         item.priority_id          = request_service.priority_id
         item.expected_at          = request_service.expected_at
         item.requested_by_user_id = request_service.requested_by_user_id
         item.comments = "From #{request_service.name}"
     end            
     self.items << item
     return item
 end
##
# get the data element type
# 
 def data_element
   parameter.data_element if parameter
 end
  
 def next_available_item
   self.items.find(:first,
                   :conditions=>'status_id between 0 and 2 and task_id is null',
                   :order => "(case when ended_at < current_date then '1' else '2' end) asc, priority_id desc, ended_at asc"  )    
     
 end
##
# Generate the unique path to this name 
# 
 def path 
    assay.name + '/' + name
 end

##
#Get a array [[status,num],] of number of items in each status
#
 def status_counts
   sql = <<SQL
   select status_id,count(data_name) num from queue_items 
   where assay_queue_id = ?
   group by status_id
SQL
   return QueueItem.find_by_sql([sql,self.id])
 end

##
#Get a array [[status,num],] of number of items in each status
#
 def priority_counts
   sql = <<SQL
   select priority_id,count(data_name) num from queue_items 
   where assay_queue_id = ?
   group by priority_id
SQL
   return QueueItem.find_by_sql([sql,self.id])
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
    "[#{items.size} / #{num_active} / #{num_finished}] #{percent_done}%"
  end

##
# Convert context to xml
# 
 def to_xml(options={})
    my_options = options.dup
    my_options[:reference] = {:parameter=>:name}
    my_options[:except] = [:assay_parameter_id] <<  my_options[:except]
    Alces::XmlSerializer.new(self, my_options  ).to_s
 end 
   
##
# Get from xml
# 
 def self.from_xml(xml,options = {})      
      my_options = options.dup
      my_options[:reference] = {:parameter=>:name}
      Alces::XmlDeserializer.new(self,my_options ).to_object(xml)
 end
 
end
