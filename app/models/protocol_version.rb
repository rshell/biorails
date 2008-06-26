# == Schema Information
# Schema version: 306
#
# Table name: protocol_versions
#
#  id                 :integer(11)   not null, primary key
#  assay_protocol_id  :integer(11)   
#  name               :string(77)    
#  version            :integer(6)    not null
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      
#  updated_at         :datetime      
#  how_to             :string(2048)  
#  report_id          :integer(11)   
#  analysis_id        :integer(11)   
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
# There are two types of protocolVersion a ProcessInstance representing a single step process
# and a ProcessFlow representing a multiple step process.
# 
# At present both present meet the same basic Process contract. 
#   * name: external name of te process
#   * parameters: collection of parameter objects which describe inputs/outputs of the process 
#   * protocol: reference to protocol which contain the description of the process aims
#   
#
#
class ProtocolVersion < ActiveRecord::Base

 validates_presence_of :protocol
 validates_presence_of :name
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
#
# Owner project
#  
  acts_as_folder :protocol
##
# This is hold in a collection of versions in of a ProcessDefinition
# 
  belongs_to :protocol, 
            :class_name => 'AssayProtocol',
            :include =>[:assay],
            :foreign_key =>'assay_protocol_id'

#
# list of experiments using this a template
#
  has_many :experiments, 
           :class_name => 'Experiment', 
           :foreign_key=>'protocol_version_id',
           :order =>'id'
         
#
# List of tasks dependent on the protocol version
#
  has_many :tasks,
             :foreign_key=>'protocol_version_id', 
             :order => :id

  
#
# description
#
def description
  "#{self.name} for #{protocol.description}"
end

 def usages
   tasks
 end

 def usage_count
   tasks.size
 end
#
# are there queues associated with this process
#
 def queues?
   false
 end
 #
 # List of queues associated with this process
 #
 def queues
   []
 end
 
 def released
   self.status ='released'
 end   

  def released?
   self.status =='released'
 end   

 def withdrawn
   self.status ='withdrawn'
 end   

  def multistep?
    false
  end    
 #
 # Its flexible if not used or released by default
 #
 def flexible?
   (!used? and !released?)
 end
 #
 # Default based on usage count
 #
 def used?
   return usages.size>0
 end
 
 def latest?
   return self == self.protocol.latest
 end
#
# Path
#  
 def path(scope='protocol')
    case scope.to_s
    when 'root','project','assay' then "#{protocol.assay.path(scope)}/#{self.protocol.name}:#{self.version}"
    else "#{self.protocol.name}:#{self.version}"
    end
 end  
  
 #
 # Get the locally definition from this version
 #
 def definition
   self.protocol
 end 
#
# List of roles which are valid to use in the scope of the protocol version
#
  def allowed_roles
     return self.protocol.assay.allowed_roles
  end
     
end
