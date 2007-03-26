##
# This is Observer to generate log events for the Study Timeline 
#
##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 

class StudyObserver < ActiveRecord::Observer
  observe Study, StudyParameter, StudyProtocol, Experiment

  def after_update(record)
      create_log(record, "Update")
  end

  def after_create(record)
      create_log(record, "Create")
  end

  def after_destroy(record)
      create_log(record, "Destory")
  end
  
 def create_log(record,mode)   
   case record
   when Study
     log = record.logs.create(:study_id => record.id, :name => record.name,
        :comment => " #{mode} study #{record.name}" )
   when StudyProtocol
     log = record.study.logs.create(:study_id => record.study_id, :name => record.name,
        :comment => " #{mode} protocol #{record.name} in study #{record.study.name}"
     )
   when StudyParameter
     log = record.study.logs.create(:study_id => record.study_id, :name => record.name,
        :comment => " #{mode} parameter #{record.name} in study #{record.study.name}"
     )
   when Experiment
     log =  record.study.logs.create(:study_id => record.study_id, :name => record.name,
        :comment => " #{mode} experiment #{record.name} in study #{record.study.name}"
     )
   else 
     return
   end   
   log.auditable = record
   log.action = mode
   log.save
 end
  
end

