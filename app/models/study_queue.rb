# == Schema Information
# Schema version: 239
#
# Table name: study_queues
#
#  id                 :integer(11)   not null, primary key
#  name               :string(128)   default(), not null
#  description        :text          
#  study_id           :integer(11)   
#  study_stage_id     :integer(11)   
#  study_parameter_id :integer(11)   
#  study_protocol_id  :integer(11)   
#  assigned_to        :string(60)    
#  status             :string(255)   default(new), not null
#  priority           :string(255)   default(normal), not null
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#

##
# This is queue of work associated with the study. This is separated from processes as 
# in really defined as start or end link in a process.
# 
# Queues of simple named items accepting a single type of data for processing in the study.
# This is governed in the same major as with fields on the process data entry grids
# 
##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class StudyQueue < ActiveRecord::Base
  included Named
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
#
# Generic rules for a name and description to be present
  validates_presence_of :name
  validates_presence_of :description

  validates_uniqueness_of :name,:scope=>'study_id'
  validates_presence_of   :study_id
  validates_presence_of   :study_stage_id
  validates_presence_of   :study_parameter_id

##
#Study 
 belongs_to :study
##
#Current process instance associated with the protocol
 belongs_to :protocol, :class_name =>'StudyProtocol',:foreign_key=>'study_protocol_id'
 
##
# Data accepted into the queue is linked to a type of Study Parameter
# to defined the source and data type. For example may well link back to compounds with a lookup
# defined in data_elements.
# 
 belongs_to :parameter, :class_name => 'StudyParameter',:foreign_key=>'study_parameter_id'

##
# Stage the protocol is linked into 
 belongs_to :stage,  :class_name =>'StudyStage',:foreign_key=>'study_stage_id'

 belongs_to :assigned_to, :class_name=>'User', :foreign_key=>'assigned_to_user_id'   
##
# Study Has a number of queues associated with it
# 
  has_many_scheduled :items, :class_name => "QueueItem",:dependent => :destroy
##
#Link to service request for work to be done
#  
  has_many_scheduled :requests, :class_name=> "RequestService",:foreign_key=>'service_id',:dependent => :destroy

##
# Add a object to the queue
#   
 def add(object,request_service=nil)
     item = QueueItem.new({ 
        :assigned_to => self.assigned_to,
        :study_parameter_id => self.study_parameter_id,
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
  
##
# Generate the unique path to this name 
# 
 def path 
    study.name + '/' + name
 end

##
#Get a array [[status,num],] of number of items in each status
#
 def status_counts
   sql = <<SQL
   select status_id,count(data_name) num from queue_items 
   where study_queue_id = ?
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
   where study_queue_id = ?
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
    my_options[:except] = [:study_parameter_id] +  my_options[:except]
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
