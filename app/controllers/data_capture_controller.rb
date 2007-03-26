##
# This is the Data Capture External API for import and export of task to other systems
# 
class DataCaptureController < ApplicationController
  wsdl_service_name 'DataCapture'
  web_service_api DataCaptureApi
  web_service_scaffold :invoke
  
    def study_list
       Study.find(:all)
    end
##
# List all the Protocols in a study
#     
    def protocol_list(study_id)  
       logger.warn "study_id is #{study_id.to_s}"
       StudyProtocol.find(:all,:conditions=>['study_id=?',study_id])
    end
##
# List all the processing 
#    
    def process_list(protocol_id)  
       ProtocolVersion.find(:all,:conditions=>['study_protocol_id=?',protocol_id],:order=>'version desc')
    end
##
#List all parameters in a process
#
    def parameter_list(protocol_id)  
       Parameter.find(:all,:conditions=>['protocol_version_id=?',protocol_id])
    end
##
#List all parameter contexts in a process
#
    def parameter_context_list(protocol_id)  
       ParameterContext.find(:all,:conditions=>['protocol_version_id=?',protocol_id])
    end

    def experiment_list(study_id)  
       Experiment.find(:all,:conditions=>['study_id=?',study_id])
    end

    def task_list(experiment_id)  
       Task.find(:all,:conditions=>['experiment_id=?',experiment_id])
    end
    
    def task_contexts(task_id)
       TaskContext.find(:all,:conditions=>['task_id=?',task_id])
    end
    

    ##
    # Get the list of value associated with a task
    # 
    def task_values(task_id)
       task = Task.find(task_id)
       task.items.collect do | item |
           DataCaptureApi::TaskItem.new(
           :id => item.id,
           :task_id => item.task_id,
           :parameter_id => item.parameter_id,
           :parameter_context_id => item.context.parameter_context_id,
           :task_context_id => item.task_context_id,
           :column_no => item.parameter.column_no,
           :row_no =>item.context.row_no,
           :value  => item.value )
       end
    end
    
    def task_create(experiment_id ,process_id ,task_name )
      experiment = Experiment.find(experiment_id)
      task = experiment.new_task
      task.name = task_name
      task.process = ProtocolVersion.find(process_id)
      task.save 
      return task
    end
    
    def task_context_create( task_id, parameter_context_id, values)
       task = Task.find(task_id)
       return nil unless task
       context = task.new_context(ParameterContext.find(parameter_context_id))
       task_context.save
       return nil unless context
       return nil unless values.size == context.definition.parameters.size
       n = 0
       for parameter in context.definition.parameters 
           task_item = context.add_task_item(parameter,values[n]) 
           task_item.save
           n +=1
       end   
       return context
    end

    def task_context_update( task_context_id, values)
       context = TaskContext.find(task_context_id)
       return nil unless context
       return nil unless values.size == context.definition.parameters.size
       n = 0
       for parameter in context.definition.parameters 
           task_item = context.item(parameter)
           task_item.value = values[n] 
           task_item.save
           n +=1
       end   
       return context
    end
    
    ##
    # Export a task 
    def task_export(task_id)
       task = Task.find(task_id)
       task.to_csv if task
    end

    ## 
    # Import a task
    def task_import(experiment_id,text_data)
       experiment = Experiment.find(experiment_id)
       experiment.import_task(text_data) if experiment
    end

    


end
