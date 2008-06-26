##
# This is Observer to generate log events for the Assay Timeline 
#
##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class CatalogObserver < ActiveRecord::Observer
  observe DataConcept, DataSystem, DataElement,DataType,DataFormat,
          ParameterType, ParameterRole, AssayStage 

  def after_update(record)
      create_log(record, "Update")
  end

  def after_create(record)
      create_log(record, "Create")
  end

  def after_destroy(record)
      create_log(record, "Destroy")
  end
  
 def create_log(record,mode)   
   log = CatalogLog.new( :comments => " #{mode} of #{record.class} with with #{record.id}" )
   if record.attributes['name']
      log.name = record.attributes['name']
   else
      log.name = record.dom_id
   end
   log.auditable = record
   log.action = mode
   log.save
 end
  
end