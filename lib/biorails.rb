# 
# biorails.rb
# 
# Created on 23-Aug-2007, 20:16:48
# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

module Biorails
  
  TEMPLATE_MODELS = [User,Role,RolePermission,Permission,
    DataConcept,DataElement,DataType,DataFormat,ParameterType,ParameterRole,
    Project,Membership,
    Study,StudyParameter,StudyQueue,StudyProtocol,
    ProtocolVersion,ParameterContext,Parameter]

  PROJECT_MODELS = [Project,ProjectElement,Asset,Content,DbFile]

  RESULTS_MODELS = [Experiment,Task,TaskContext,TaskValue,TaskText,TaskReference]

  CATALOG_MODELS = [DataConcept,DataElement,DataType,DataFormat,ParameterType,ParameterRole]

  ALL_MODELS = [User,Role,RolePermission,Permission,
    DataConcept,DataElement,DataType,DataFormat,ParameterType,ParameterRole,
    Compound,Batch,Plate,Container,
    Project,Membership,
    ProjectElement,Asset,Content,DbFile,
    Study,StudyParameter,StudyQueue,StudyProtocol,
    ProtocolVersion,ParameterContext,Parameter,
    Request,RequestService,QueueItem,
    Report,ReportColumn,
    Experiment,Task,TaskContext,TaskValue,TaskText,TaskReference]
  
module Version
    MAJOR  = 1
    MINOR  = 10
    TINY   = 815
    STRING = [MAJOR, MINOR, TINY].join('.').freeze
    TITLE  = "Biorails".freeze
  end
      
end
