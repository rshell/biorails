##
# This is Observer to generate log events for the Study Timeline 
#
##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 
class ExperimentObserver < ActiveRecord::Observer
  observe Experiment, Task

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
   case record
   when Experiment
     log = record.logs.create(:experiment_id => record.id, :name => record.name,
        :comment => " #{mode} study #{record.name}" )
   when Task
     log = record.experiment.logs.create(:experiment_id => record.experiment_id, :name => record.name,
        :comment => " #{mode} task #{record.name} in experiment #{record.name}"
     )
   else 
     return
   end   
   log.auditable = record
   log.action = mode
   log.save
 end
  
end
