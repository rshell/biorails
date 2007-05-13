# == Schema Information
# Schema version: 239
#
# Table name: studies
#
#  id                 :integer(11)   not null, primary key
#  name               :string(128)   default(), not null
#  description        :text          
#  category_id        :integer(11)   
#  research_area      :string(255)   
#  purpose            :string(255)   
#  lock_version       :integer(11)   default(0), not null
#  created_at         :datetime      not null
#  updated_at         :datetime      not null
#  project_id         :integer(11)   
#  updated_by_user_id :integer(11)   default(1), not null
#  created_by_user_id :integer(11)   default(1), not null
#
##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
###
# Studies manage the logical organization and tracking of work for reporting. A study may 
# have a number of protocols (linked Processed) associated with it and a large number of 
# experiments run containing tasked used to managed data collected by running the protocols.
#   

class Study < ActiveRecord::Base
  included Named
##
# This item can be scheduled 
#
  acts_as_scheduled :summary_of=>:experiments
##
# This record has a full audit log created for changes 
#   
  acts_as_audited :change_log
  
  acts_as_ferret  :fields => {:name =>{:boost=>2,:store=>:yes} , 
                              :description=>{:store=>:yes,:boost=>0},
                              :research_area=>{:boost=>1},
                              :purpose=>{:boost=>0} }, 
                   :default_field => [:name],           
                   :single_index => true, 
                   :store_class_name => true 

#
# Generic rules for a name and description to be present
  validates_uniqueness_of :name,:scope=>:project_id

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :project_id


##
#Owner project
#  
  belongs_to :project  

##
# Logs on the Study Timeline 
#   
  has_many :logs, :class_name => "StudyLog", 
                  :as => :auditable, 
                  :dependent => :destroy

##
# Link to view for summary stats for study
# 
  has_many :stats, :class_name => "StudyStatistics"

##
# Study Has a number of queues associated with it
# 
  has_many :queues, :class_name => "StudyQueue",:dependent => :destroy

##
#  has many project elements associated with it
#  
  has_many :elements, :class_name=>'ProjectElement' ,:as => :reference, :dependent => :destroy

##
# The study has a collection of protocols assocated with it
#
  has_many :protocols ,
   :class_name => "StudyProtocol",
   :foreign_key => "study_id",
   :order => "study_stage_id desc",
   :dependent => :destroy

#   has_many 'analysis_methods' ,
#   :class_name => "AnalysisDefinition",
#   :foreign_key => "study_id",
#   :order => "study_stage_id desc",
#   :dependent => :destroy
 
##
# List of experiments carried out for this study
# 
  has_many_scheduled :experiments,  :class_name=>'Experiment',
                     :foreign_key =>'study_id',:dependent => :destroy,:order => "name desc"

##
# The study has a collection of prefered parameters and roles assocated with it
#
  has_many :parameters ,
   :class_name => "StudyParameter",
   :foreign_key => "study_id",
   :order => "parameter_role_id,parameter_type_id",
   :dependent => :destroy

#
# Get the folder for this study
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
# Get the named protocol from the list attrached to the study
# 
  def protocol(name)
    return self.protocols.detect{|i|i.name == name}
  end

##
# Get the named experiment from the list attrached to the study
# 
  def experiment(name)
    return self.experiments.detect{|i|i.name == name}
  end
##
# Get a list of all roles used in the study
#
  def allowed_roles
     return parameters.collect{|p| p.role }.uniq
  end

##
# Get all the parameters with this role
# in no role is specified then return a unique list of parameters
# 
  def parameters_for_role(role)
      if !role.nil? 
          return parameters.reject{|p| p.role != role}
      else    
          return parameters
      end 
  end 
  

##
# Get all the parameters with this role
# in no role is specified then return a unique list of parameters
# 
  def parameters_for_data_type(data_type_id)
     return parameters.reject{|p| p.data_type_id != data_type_id}
  end 
  

##
# List all tasks assocated with this study 
  def tasks
    sql = "select t.* from tasks t,experiments e where e.id = t.experiment_id and e.study_id = ?"
    return Task.find_by_sql([sql,self.id])
  end
  
##
# get all protocols in a specific stage of the study
# 
  def protocols_in_stage( stage = nil )
      if !stage.nil? 
          return protocols.reject{|p| p.stage != stage}
      else    
          return protocols
      end 
  end   

##
# get all protocols in a specific stage of the study
# 
  def queues_in_stage( stage = nil )
      if !stage.nil? 
          return queues.reject{|p| p.stage != stage}
      else    
          return queues
      end 
  end   
   
##
# get a list of the processes for a stage
   def processes(stage = nil)
      return protocols(stage).collect{|p|p.process}
   end

##
# Get all the stages linked into this study   
# 
   def stages
      StudyStage.find(:all)
   end

##
# get all the ParameterRoles linked into this study   
   def parameter_roles(type = nil )
     if type
        ParameterRole.find_by_sql(
        ["SELECT * FROM parameter_roles a where exists (select 1 from study_parameters b where b.parameter_role_id= a.id and b.study_id=? and b.parameter_type_id=?)",id,type.id])
     else
        ParameterRole.find_by_sql(
        ["SELECT * FROM parameter_roles a where exists (select 1 from study_parameters b where b.parameter_role_id= a.id and b.study_id=?)",id])
     end 
   end

##
# get all the ParameterType linked into this study
   def parameter_types(role = nil)
     if role
       ParameterRole.find_by_sql(
       ["SELECT * FROM parameter_types a where exists (select 1 from study_parameters b  where b.parameter_type_id= a.id and b.parameter_role_id=? and b.study_id=?)",role.id,id])     
     else
       ParameterRole.find_by_sql(
       ["SELECT * FROM parameter_types a where exists (select 1 from study_parameters b  where b.parameter_type_id= a.id and b.study_id=?)",id])
     end
   end

##
# Pivot study parameters int of type v.s. roles hashed grid   
   def parameter_grid
      last = 0
      columns = Hash.new
      grid = Hash.new
      for item in self.stats
        if last != item.parameter_type_id
           grid[last]= columns
           columns = Hash.new
           last= item.parameter_type_id
        end
        columns[item.parameter_role_id] = item
      end
      return grid
   end

 
 def to_xml(options = {})
      my_options = options.dup
      my_options[:include] ||= [:parameters,:queues,:protocols]
      Alces::XmlSerializer.new(self, my_options  ).to_s
 end

##
# Get Study from xml
# 
 def self.from_xml(xml,options = {})
      my_options = options.dup
      my_options[:include] ||= [:parameters,:queues,:protocols]
      Alces::XmlDeserializer.new(self,my_options ).to_object(xml)
 end

end
