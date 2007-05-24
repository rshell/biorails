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
    def version
      Biorails::Version::STRING    
    end
 #
 # Login returning a session id (currently a little weaks as its the user record)
 # @param username 
 # @param password
 #
    def login( username, password)
      user = User.authenticate(username,password)
      User.current_user =user
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
       items = ProjectElement.find(:all,:conditions=>['project_id=?',id],:order=>'parent_id,id')
       items.collect do |item|
           DataCaptureApi::Element.new(
           :id => item.id,
           :folder_id => item.parent_id,
           :name => item.name,
           :path => item.path,
           :summary => item.summary,
           :style => item.style,
           :icon  => item.icon,
           :asset_id => item.asset_id,
           :content_id => item.content_id,
           :reference_id => item.reference_id,
           :reference_type => item.reference_type)
       end
    end

#
# List of all project elements in order parent_id,name for 
# easy creation of a tree structure on client (Hash and fill)
#
    def project_folder_list(id)
       ProjectFolder.find(:all,:conditions=>['project_id=?',id],:order=>'parent_id,id')
    end
#    
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

    def get_project(id)
      Project.find(id)      
    end

    def get_study(id)
      Study.find(id)      
    end

    def get_study_protocol(id)
      StudyProtocol.find(id)      
    end

    def get_protocol_version(id)
      ProtocolVersion.find(id)      
    end

    def get_experiment(id)
      Expriment.find(id)      
    end

    def get_task(id)
      Task.find(id)      
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
       User.current_user = User.find(user_id)
       experiment = Experiment.find(experiment_id)
       experiment.import_task(text_data) if experiment
    end

    
    def add_task(user_id,experiment_id ,process_id ,task_name )
       User.current_user = User.find(user_id)
      experiment = Experiment.find(experiment_id)
      task = experiment.new_task
      task.name = task_name
      task.process = ProtocolVersion.find(process_id)
      task.save 
      return task
    end
    
    def add_task_context(user_id, task_id, parameter_context_id, values)
       User.current_user = User.find(user_id)
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


     def set_asset( user_id,folder_id,title,filename,mime_type, base64 )
       User.current_user = User.find(user_id)
       folder = ProjectFolder.find(folder_id)
       asset = ProjectAsset.new(:title=>title, :filename=> filename, :project_id=>folder.project_id,:content_type => mime_type)
       asset.size =0
       asset.temp_data = Base64.decode64(base64) 
       if asset.save 
          logger.info " asset saved"
          element  = folder.elements.find_by_name(filename)
          unless element
            logger.info " element added"
             element = folder.add_asset(filename,asset)
          else
            logger.info " element updated"
             element.asset = asset
             element.save
          end
          logger.info element.to_yaml
          return element.id
       else 
          logger.error " Set_asset failed Errors: #{asset.errors.full_messages.to_sentence}"
       end
       return 0
     end

     
     def get_asset( element_id)
       element = ProjectElement.find(element_id)
       return nil unless element and element.asset_id
       DataCaptureApi::Asset.new(
             :id => element.asset.id,
             :folder_id  => element.parent_id,
             :project_element_id  => element.id,
             :name => element.asset.filename,
             :title => element.asset.title,
             :mime_type => element.asset.content_type,
             :base64  => Base64.encode64(element.asset.db_file.data )
             )
     end


     def set_content( user_id,folder_id,title,filename, html)
       User.current_user = User.find(user_id)
       folder = ProjectFolder.find(folder_id)
       element = folder.add_content(name,title,html)
     end
ProjectElement


     def get_content( element_id)
       element = ProjectElement.find(element_id)
       return nil unless element and element.content_id
       DataCaptureApi::Content.new(
             :id => element.id,
             :folder_id  => element.parent_id,
             :project_element_id  => element.id,
             :name => element.name,
             :title => element.title,
             :data  =>element.to_html
             )
     end

end
