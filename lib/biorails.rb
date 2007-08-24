# 
# biorails.rb
# 
# Created on 23-Aug-2007, 20:16:48
# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

module Biorails
  
  TEMPLATE_MODELS = [Role,User,Identifier,Permission,RolePermission,
    DataConcept,DataSystem,DataElement,DataType,DataFormat,ParameterType,ParameterRole,
    Project,Membership,
    Study,StudyParameter,StudyQueue,StudyProtocol,
    ProtocolVersion,ParameterContext,Parameter]

  PROJECT_MODELS = [Project,ProjectElement,Asset,Content,DbFile]

  RESULTS_MODELS = [Experiment,Task,TaskContext,TaskValue,TaskText,TaskReference]

  CATALOG_MODELS = [DataConcept,DataSystem,DataElement,DataType,DataFormat,ParameterType,ParameterRole]

  ALL_MODELS = [Role,User,Identifier,Permission,RolePermission,
    DataConcept,DataSystem,DataElement,DataType,DataFormat,ParameterType,ParameterRole,
    Compound,Batch,Plate,Container,
    Project,Membership,
    ProjectElement,Asset,Content,DbFile,
    Study,StudyParameter,StudyQueue,StudyProtocol,
    ProtocolVersion,ParameterContext,Parameter,
    Request,RequestService,QueueItem,
    Report,ReportColumn,
    Experiment,Task,TaskContext,TaskValue,TaskText,TaskReference]


##
# Get a List of all the Models
#   
  def models
    unless @@models
      for file in Dir.glob("#{RAILS_ROOT}/app/models/*.rb") do
        begin
          load file
        rescue
          logger.info "Couldn't load file '#{file}' (already loaded?)"
        end
      end  
    end
    @@models = []

    ObjectSpace.each_object(Class) do |klass|
      if klass.ancestors.any?{|item|item==ActiveRecord::Base} and !klass.abstract_class
        @@models << klass unless @@models.any?{|item|item.to_s == klass.to_s}
      end
    end

    @@models -= [ActiveRecord::Base, CGI::Session::ActiveRecordStore::Session]
    return @@models.sort{|a,b| a.to_s <=> b.to_s }

  rescue Exception => ex
    logger.error "Failed to find models #{ex.message}"
    return []
  end
  
module Version
    MAJOR  = 1
    MINOR  = 10
    TINY   = 815
    STRING = [MAJOR, MINOR, TINY].join('.').freeze
    TITLE  = "Biorails".freeze
  end
      
end
