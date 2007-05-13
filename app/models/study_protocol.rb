# == Schema Information
# Schema version: 239
#
# Table name: study_protocols
#
#  id                    :integer(11)   not null, primary key
#  study_id              :integer(11)   not null
#  study_stage_id        :integer(11)   default(1), not null
#  current_process_id    :integer(11)   
#  process_definition_id :integer(11)   
#  process_style         :string(128)   default(Entry), not null
#  name                  :string(128)   default(), not null
#  description           :text          
#  literature_ref        :text          
#  protocol_catagory     :string(20)    
#  protocol_status       :string(20)    
#  lock_version          :integer(11)   default(0), not null
#  created_at            :datetime      not null
#  updated_at            :datetime      not null
#  updated_by_user_id    :integer(11)   default(1), not null
#  created_by_user_id    :integer(11)   default(1), not null
#

##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
##
# This links a protocol_version into a Study as a Protocol to be run in the study
# 
# There are a number of sub types of a protocol
# 
#  * Entry/ProcessDefinition with a implementation as a ProtocolVersion
#  * ReportDefinition this a report run in the context of a experiment
#  * AnalysisDefinition this is a data transformation run in the context of a experiment
# 
# 
class StudyProtocol < ActiveRecord::Base
  included Named
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
##
# Protocol is identified by a unique name
# 
  validates_uniqueness_of :name, :scope =>"study_id"
  validates_presence_of   :name
  validates_presence_of   :description
  validates_presence_of   :study_id
  validates_presence_of   :study_stage_id

##
#Study 
 belongs_to :study
##
#Current process instance associated with the protocol
 belongs_to :process, :class_name =>'ProtocolVersion',:foreign_key=>'current_process_id'
##
# The implementations are held in as a collection of versions in reverse order
# of the version number.
#
  has_many :versions ,
   :class_name => "ProtocolVersion",
   :order => "version desc",
   :dependent => :destroy

##
# Stage the protocol is linked into 
 belongs_to :stage,  :class_name =>'StudyStage',:foreign_key=>'study_stage_id'

##
# Is the default option for a number of experiments 
 has_many :experiments, :dependent => :destroy
##
#  has many project elements associated with it
#  
  has_many :elements, :class_name=>'ProjectElement' ,:as => :reference,:dependent => :destroy

 has_many :tasks, :finder_sql => ' select t.* from tasks t, protocol_versions v where t.protocol_version_id = v.id and v.study_protocol_id= #{id}'
##
# 
 def definition
  return self
 end


#
# Get the folder for this protocol
#
  def folder(item=nil)
    folder = self.study.folder(self)
    if item
      return folder.folder(item)
    else
      return folder
    end
  end  
##
# Get a Editable version of perocess 
# 
 def editable
    self.process = self.current_version unless self.process 
    if not process.is_used
      logger.info "Using lastest #{self.process.id}"
      process  
    elsif not lastest.is_used
      logger.info "Using lastest #{self.lastest.id}"
      lastest 
    else 
      logger.info "Creating copy of #{self.id}"
      process.copy
    end
 end


#
#   Return the most current implementation of the process definition
#   return ProcessInstance 
#   
   def current_version
       version = ProtocolVersion.find(:first,
                            :conditions=>["study_protocol_id = ?",self.id],
                            :order =>" version DESC") 
   end
   
 # Create a new Implementation of the Process 
 #
   def new_version
       instance = ProtocolVersion.new( :protocol => self,
                                      :name => self.name )
       last = ProtocolVersion.find(:first,
                            :conditions=>["study_protocol_id = ?",self.id],
                            :order =>" version DESC")                             
       instance.version = (last!=nil ? last.version + 1 : 1) 
       instance.name = self.name+":"+String(instance.version)                                                
       versions << instance
       return instance
   end       

##
#Get the latest version of the process
#
 def lastest
  return versions[0]
 end
 
##
# Get a specific version of the protocol. 
# 
 def version( version)
   versions.detect{|i|i.version == version}
 end
 
##
# Get the linked process with the given id
# 
 def process_by_id( id)
   versions.detect{|i|i.id == id}
 end
     

##
# Get the number of times all version of this protocol have been used in a task
# 
 def usage_count
  sql =" select count(t.id) from tasks t,protocol_versions p,study_protocols s
    where t.protocol_version_id =p.id
    and s.id = p.study_protocol_id 
    and s.id = ? "
    return Task.count_by_sql( [sql ,self.id])  
 end
 
 def to_xml(options = {})
      my_options = options.dup
      my_options[:reference] ||= {:process=>:name}
      my_options[:except] = [:process] + options[:except]
      my_options[:include] = [:versions, :stage]
     Alces::XmlSerializer.new(self, my_options ).to_s
 end

##
# Get from xml
# 
 def self.from_xml(xml,options = {})
      my_options = options.dup
      my_options[:except] = [:process] + options[:except]
      my_options[:include] = [:versions,:stage]
      Alces::XmlDeserializer.new(self,my_options ).to_object(xml)
 end
 
 
end
