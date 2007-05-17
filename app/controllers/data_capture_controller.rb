##
# This is the Data Capture External API for import and export of task to other systems
# 
class DataCaptureController < ApplicationController
  wsdl_service_name 'DataCapture'
  web_service_api DataCaptureApi
  web_service_scaffold :invoke

  #
  # Simple test function to see it web service API is wrong
  #
    def study_count
      Study.count(:all)    
    end
 #
 # Login returning a session id (currently a little weaks as its the user record)
 # @param username 
 # @param password
 #
    def login( username, password)
      user = User.authenticate(username,password)
      if user
          logger.info "User #{username} successfully logged in"
          set_user(user)
          set_project(user.projects[0])    
      end
      return user
    end
  #
  # List of of projects for the current user
  # 
    def project_list(session_id)
       user = User.find(session_id)
       user.projects
    end
#
# List of all project elements in order parent_id,name for 
# easy creation of a tree structure on client (Hash and fill)
#
    def project_element_list(id)
       Project.find(id).elements
    end
#
#
#
    def study_list(project_id)
       Project.find(project_id)
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
    
    def task_context_list(task_id)
       TaskContext.find(:all,:conditions=>['task_id=?',task_id])
    end
    

    ##
    # Get the list of value associated with a task
    # 
    def task_value_list(task_id)
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
    def task_import(user_id,experiment_id,text_data)
       User.current = User.find(user_id)
       experiment = Experiment.find(experiment_id)
       experiment.import_task(text_data) if experiment
    end


     def add_asset( user_id,folder_id,title,filename,mime_type, data)
       User.current = User.find(user_id)
       folder = ProjectFolder.find(folder_id)
       element = folder.add_file(filename,title, mime_type)
     end

     def add_content( user_id,folder_id,title,filename, html)
       User.current = User.find(user_id)
       folder = ProjectFolder.find(folder_id)
       element = folder.add_content(name,title,html)
     end

end
