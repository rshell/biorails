##
# This is the Data Capture External API for import and export of task to other systems
# 
class BiorailsController < ApplicationController
  wsdl_service_name 'Biorails'
  web_service_api BiorailsApi
  web_service_scaffold :invoke

   layout 'printout'
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
      if user and user.enabled?
         logger.info "User #{username} successfully logged in"
          set_user(user)
          set_project(user.projects[0])    
      end
      return user.id.to_s
    end
  #
  # List of of projects for the current user
  # 
  # @return [Project]
  # 
    def project_list(session_id)
       user = User.find(session_id)
       retrun user.projects
    end
#
# List of all project elements in order parent_id,name for 
# easy creation of a tree structure on client (Hash and fill)
# 
# @return [ProjectElement] all project elements sorted in tree order
#
    def project_element_list(session_id,id)
       items = ProjectElement.find(:all,:conditions=>['project_id=?',id],:order=>'left_limit,id')
       items.collect do |item|
           BiorailsApi::Element.new(
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
#  @return [Element] get a Elements in a folder
#
    def project_folder_list(session_id,id)
       items = ProjectFolder.find(:all,:conditions=>['project_id=?',id],:order=>'left_limit,id')
       items.collect do |item|
           BiorailsApi::Element.new(
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
# List of all studies in a project
# 
# @param 
#
# @return [Study] array of studies in a project
#
    def study_list(session_id,project_id)
       user = User.find(session_id)
       project = Project.find(project_id)
       return project.studies
    end
##
# List all the Protocols in a study
# 
#  @return [StudyProtocol]  
#     
    def study_protocol_list(session_id,study_id)  
       user = User.find(session_id)
       protocols = StudyProtocol.find(:all,:conditions=>['study_id=?',study_id],:order=>'id')
       return protocols;
    end
##
# List all the processing 
#    
    def protocol_version_list(session_id,study_protocol_id)  
       user = User.find(session_id)
       return ProtocolVersion.find(:all,:conditions=>['study_protocol_id=?',study_protocol_id],:order=>'version desc')
    end
##
#List all parameter contexts in a process
#
    def parameter_context_list(session_id,protocol_id)  
       ParameterContext.find(:all,:conditions=>['protocol_version_id=?',protocol_id],:order=>'id')
    end
##
#List all parameters in a process
# 
# @params protocol_version_id
# @params context_id 0/null for all  
#
# @return [Parameters]
#
    def parameter_list(session_id,protocol_version_id,parameter_context_id)  
      user = User.find(session_id)
      if context_id and context_id >0
        return Parameter.find(:all,:conditions=>['protocol_version_id=? and parameter_context_id=?',
                      protocol_version_id,parameter_context_id],:order=>'column_no')
      else
        return Parameter.find(:all,:conditions=>['protocol_version_id=?',protocol_version_id],:order=>'column_no')
      end  
    end

    def experiment_list(session_id,study_id)  
       Experiment.find(:all,:conditions=>['study_id=?',study_id],:order=>'id')
    end

    def task_list(session_id,experiment_id)  
       Task.find(:all,:conditions=>['experiment_id=?',experiment_id],:order=>'id')
    end
    
    def task_context_list(session_id,task_id)
       TaskContext.find(:all,:conditions=>['task_id=?',task_id],:order=>'id')
    end

    ##
    # Get the list of value associated with a task
    # 
    def task_value_list(session_id,task_id)
       task = Task.find(task_id)
       return task.items.collect do | item |
           BiorailsApi::TaskItem.new(
           :id => item.id,
           :task_id => item.task_id,
           :parameter_id => item.parameter_id,
           :parameter_context_id => item.context.parameter_context_id,
           :task_context_id => item.task_context_id,
           :column_no => item.parameter.column_no,
           :row_no =>item.context.row_no,
           :value  => item.value,
           :unit   => (item.respond_to?(:storage_unit) ? item.storage_unit : nil), 
           :text   => item.to_s )
       end
    end

    def get_project(session_id,id)
      Project.find(id)      
    end

    def get_study(session_id,id)
      Study.find(id)      
    end

    def get_study_protocols(session_id,id)
      StudyProtocol.find(id)      
    end

    def get_protocol_version(session_id,id)
      ProtocolVersion.find(id)      
    end

    def get_experiment(session_id,id)
      Experiment.find(id)      
    end

    def get_task(session_id,id)
      Task.find(id)      
    end

    def get_study_xml(session_id,id)
      study = Study.find(id)      
      study.to_xml if study
    end
    
    def get_task_xml(session_id,id)
      task = Task.find(id)
      task.to_xml if task      
    end    
#
# Get a list of matching choices for a data Element for a client lookup
#
    def get_choices(session_id,id,matches)
      element =DataElement.find( id )
      choices = element.like(matches)
      return choices.collect{|i|i['name']}
    end
#
# Get a reports out as a soap web services
#
    def get_report(session_id,id)
      @report = Report.find(id)
      @data = @report.run    
      return render_to_string :partial => 'shared/report_printout', :locals=>{:report =>  @report, :data => @data}
    end
    
    ##
    # Export a task 
    def task_export(session_id,task_id)
       task = Task.find(task_id)
       task.to_csv if task
    end

    ## 
    # Import a task
    def task_import(session_id,experiment_id,text_data)
       User.current = User.find(session_id)
       experiment = Experiment.find(experiment_id)
       experiment.import_task(text_data) if experiment
    end

    
    def add_experiment(session_id,project_id,protocol_id,name,description)
      User.current = User.find(session_id)
      Project.current = Project.find(project_id)
      experiment = Experiment.new( :name=>name, :description=>description)
      experiment.project = Project.current
      experiment.protocol =StudyProtocol.find(protocol_id)
      if experiment.save
          folder = experiment.folder       
      end
      return experiment
    end
    
    def add_task(session_id,experiment_id ,protocol_version_id ,task_name )
      User.current = User.find(session_id)
      experiment = Experiment.find(experiment_id)
      task = experiment.new_task
      task.name = task_name
      task.process = ProtocolVersion.find(protocol_version_id)
      task.save 
      return task
    end
    #
    # Create a filled results row
    # 
    # @params parameter_context_id
    # @params values in order of column_no
    #
    def add_task_context(session_id, task_id, parameter_context_id, values)
       User.current = User.find(session_id)
       task = Task.find(task_id)
       return nil unless task
       
       definition = ParameterContext.find(parameter_context_id);
       return nil unless definition.process_id == task.process_id
       
       context = task.new_context(definition)
       task_context.save
       return nil unless context
       return nil unless values.size == context.definition.parameters.size
       n = 0
       for parameter in definition.parameters 
           task_item = context.add_task_item(parameter,values[n]) 
           task_item.save
           n +=1
       end   
       return context
    end 

     def get_asset(session_id, element_id)
       element = ProjectElement.find(element_id)
       return nil unless element and element.asset_id
       BiorailsApi::Asset.new(
             :id => element.asset.id,
             :folder_id  => element.parent_id,
             :project_element_id  => element.id,
             :name => element.asset.filename,
             :title => element.asset.title,
             :mime_type => element.asset.content_type,
             :base64  => Base64.encode64(element.asset.db_file.data )
             )
     end


     def set_asset( user_id, folder_id, title, filename, mime_type, base64 )
       User.current = User.find(user_id)
       folder = ProjectFolder.find(folder_id)    
       element = folder.add_asset( filename, title, mime_type, Base64.decode64(base64) )
        logger.info element.to_yaml
        BiorailsApi::Asset.new(
           :id => element.asset.id,
           :folder_id  => element.parent_id,
           :project_element_id  => element.id,
           :name => element.asset.filename,
           :title => element.asset.title,
           :mime_type => element.asset.content_type,
           :base64  => Base64.encode64(element.asset.db_file.data )
         )
     end

     
     def get_content( session_id, element_id)
       element = ProjectElement.find(element_id)
       return nil unless element and element.content_id
       BiorailsApi::Content.new(
             :id => element.id,
             :folder_id  => element.parent_id,
             :project_element_id  => element.id,
             :name => element.name,
             :title => element.title,
             :data  =>element.to_html
             )
     end
     
     def set_content( user_id,folder_id, title,name, html)
       User.current = User.find(user_id)
       folder = ProjectFolder.find(folder_id)
       element = folder.add_content(name,title,html)
       BiorailsApi::Content.new(
             :id => element.id,
             :folder_id  => element.parent_id,
             :project_element_id  => element.id,
             :name => element.name,
             :title => element.title,
             :data  =>element.to_html
             )
     end

#
# get folder as html
#


end
