# ##
# Copyright � 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights ##
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
          set_user(user) if session
          set_project(user.projects[0]) if session    
      end
      return user.id.to_s
    rescue Exception => ex
      logger.error "failed to login: #{ex.message}"
      return nil
    end
  #
  # List of of projects for the current user
  # 
  # @return [Project]
  # 
    def project_list(session_id)
       setup_session(session_id)
       return @current_user.projects
    end
#
# List of all project elements in order parent_id,name for 
# easy creation of a tree structure on client (Hash and fill)
# 
# @return [ProjectElement] all project elements sorted in tree order
#
    def project_element_list(session_id,id)
       setup_session(session_id,id)
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
# @return [ProjectElement] all project elements sorted in tree order
#
    def folder_element_list(session_id,id)
       setup_session(session_id,id)
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
       setup_session(session_id,id)
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
# List of all assays in a project
# 
# @param 
#
# @return [Assay] array of assays in a project
#
    def assay_list(session_id,project_id)
       setup_session(session_id,project_id)
       return @current_project.assays 
    end
##
# List all the Protocols in a assay
# 
#  @return [AssayProtocol]  
#     
    def assay_protocol_list(session_id,assay_id)        
       setup_session(session_id,nil)
       assay = @current_user.assay(assay_id)
       return [] unless assay
       protocols = AssayProcess.find(:all,:conditions=>['assay_id=?',assay_id],:order=>'name')
       return protocols;
    end
##
# List all the Protocols(Single step processes only) in a assay
# 
#  @return [AssayProtocol]  
#     
    def assay_workflow_list(session_id,assay_id)  
       setup_session(session_id,nil)
       assay = @current_user.assay(assay_id)
       return [] unless assay
       protocols = AssayWorkflow.find(:all,:conditions=>['assay_id=?',assay_id],:order=>'name')
       return protocols;
    end
#
# List of releast processes
#
#
    def process_instance_list(session_id,project_id)
       setup_session(session_id,project_id)
       list = []
       Project.current.protocols.each do |item|
          if item.released and item.is_a?(AssayProcess)
            list << item.released
          end
       end
       return list
    end
##
# List all the processing 
#    
    def protocol_version_list(session_id,assay_protocol_id)  
       setup_session(session_id)
       return ProcessInstance.find(:all,:conditions=>['assay_protocol_id=?',assay_protocol_id],:order=>'version desc')
    end
##
# List all the processing 
#    
    def process_flow_list(session_id,project_id)  
       setup_session(session_id,project_id)
       list = []
       Project.current.protocols.each do |item|
          if item.released and item.is_a?(AssayWorkflow)
            list << item.released
          end
       end
       return list
    end
##
# List the steps in a process flow
#    
    def process_steps_list(session_id,protocol_version_id)  
       setup_session(session_id)
       return ProcessStep.find(:all,:conditions=>['process_flow_id=?',protocol_version_id],:order=>'version desc')
    rescue 
      return nil
    end
##
#List all parameter contexts in a process
#
    def parameter_context_list(session_id, protocol_id)  
       setup_session(session_id)
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
       setup_session(session_id)
      if parameter_context_id and parameter_context_id >0
        return Parameter.find(:all,
               :conditions=>['protocol_version_id=? and parameter_context_id=?',
                      protocol_version_id,parameter_context_id],
               :order=>'column_no')
      else
        return Parameter.find(:all,
               :conditions=>['protocol_version_id=?',protocol_version_id],
               :order=>'column_no')
      end  
    end

    def experiment_list(session_id,assay_id)  
       setup_session(session_id)
       Experiment.find(:all,:conditions=>['assay_id=?',assay_id],:order=>'id')
    end

    def task_list(session_id,experiment_id)  
       setup_session(session_id)
       Task.find(:all,:conditions=>['experiment_id=?',experiment_id],:order=>'id')
    end
    
    def task_mine_list(session_id)
      user =  setup_session(session_id)
      return nil unless user
        Task.find(:all,:conditions=>['assigned_to_user_id=? and status_id in (0,1,2,3,4)', 
          user.id],:order=>'id')
    rescue 
      return nil
    end
    
    def task_context_list(session_id,task_id)
       setup_session(session_id)
       TaskContext.find(:all,:conditions=>['task_id=?',task_id],:order=>'id')
    end
    ##
    # Get the list of value associated with a task
    # 
    def task_value_list_by_context( session_id, task_id, parameter_context_id )
       setup_session(session_id)
       task = User.current.task(task_id)
       return [] unless task       
       items = []
       task.items.collect do | item |
           if item.context.parameter_context_id == parameter_context_id 
             items << BiorailsApi::TaskItem.new(
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
       return items
    end
    ##
    # Get the list of value associated with a task
    # 
    def task_value_list(session_id,task_id)
       setup_session(session_id)
       task = User.current.task(task_id)
       return [] unless task       
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
       setup_session(session_id,id)
       return Project.current
    end

    def get_assay(session_id,id)
       setup_session(session_id)
      Assay.find(id)      
    end

    def get_assay_protocol(session_id,id)
       setup_session(session_id)
      AssayProtocol.find(id)      
    end

    def get_protocol_version(session_id,id)
       setup_session(session_id)
      ProtocolVersion.find(id)      
    end

    def get_experiment(session_id,id)
       setup_session(session_id)
      Experiment.find(id)      
    end

    def get_task(session_id,id)
       setup_session(session_id)
      Task.find(id)      
    end

    def get_assay_xml(session_id,id)
       setup_session(session_id)
      assay = Assay.find(id)      
      assay.to_xml if assay
    end
    
    def get_task_xml(session_id,id)
       setup_session(session_id)
      task = Task.find(id)
      task.to_xml if task      
    end    
#
# Get a list of matching choices for a data Element for a client lookup
#
    def get_choices(session_id,id,matches)
       setup_session(session_id)
      element =DataElement.find( id )
      choices = element.like(matches)
      return choices.collect{|i|i['name']}
    end
#
# Get a reports out as a soap web services
#
    def get_report(session_id,id,page)
       setup_session(session_id)
      @report = Report.find(id)
      @data = @report.run({:page=>page})    
      return render_to_string( :partial => 'shared/report_printout', :locals=>{:report =>  @report, :data => @data})
    rescue 
      return nil
    end
    
    ##
    # Export a task 
    def task_export(session_id,task_id)
       setup_session(session_id)
       task = User.current.task(task_id)
       return "" unless task
       task.to_csv
    end

    ## 
    # Import a task
    def task_import(session_id,experiment_id,text_data)
       setup_session(session_id)
       experiment = User.current.experiment(experiment_id)
       raise("Experiment [#{experiment_id} is not visible for user #{User.current.login}") unless experiment
       experiment.import_task(text_data) 
    end
    #
    # Get the next valid for a named external identifier
    #
    def next_identifier(name)
      return Identifier.next_id(name)
    end   
    #
    # Add a Project to the system
    #
    def add_project(session_id,name,description,project_type_id)
      setup_session(session_id)
      project = current_user.create_project(:name=>name,
        :description=>description,
        :project_type_id=>project_type_id)
      project.save!
        set_project(@project)
      return project
    end  
    #
    # Add a Experiment
    #
    def add_experiment(session_id,project_id,protocol_version_id,name,description)
      setup_session(session_id,project_id)
      Experiment.transaction do 
        experiment = Experiment.new( :name=>name, :description=>description)
        experiment.project = Project.current
        process = ProtocolVersion.find(protocol_version_id)
        experiment.process = process
        experiment.assay_id = process.protocol.assay_id
        experiment.save!
        experiment.folder       
        return experiment
      end
    end
    
    def add_task(session_id,experiment_id ,protocol_version_id ,task_name )
      setup_session(session_id)
      Task.transaction do
        experiment = Experiment.find(experiment_id)
        task = experiment.add_task(:name => task_name, :protocol_version_id =>protocol_version_id)
        task.save! 
        task.folder
        return task
      end
    end
    #
    # Create a filled results row
    # 
    # @params parameter_context_id
    # @params values in order of column_no
    #
    def add_task_context(session_id, task_id, parameter_context_id)
       setup_session(session_id)
       Task.transaction do
         task = Task.find(task_id)
         definition = ParameterContext.find(parameter_context_id);
         context =  task.add_context(definition)
         context.save!
         return context
       end
    end

    def set_task_value(session_id, task_context_id, parameter_id, data)      
      setup_session(session_id)
       Task.transaction do
         context = TaskContext.find(task_context_id)
         parameter = Parameter.find(parameter_id);
         item = context.item(parameter.name)
         item.value = data
         item.save!
         return BiorailsApi::TaskItem.new(
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
    
    def get_asset(session_id, element_id)
       setup_session(session_id)
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


     def set_asset( session_id, folder_id, title, filename, mime_type, base64 )
       setup_session(session_id)
       ProjectElement.transaction do
          folder = ProjectFolder.find(folder_id)    
          element = folder.add_asset( filename, title, mime_type, Base64.decode64(base64) )
          element.save!
          return BiorailsApi::Asset.new(
             :id => element.asset.id,
             :folder_id  => element.parent_id,
             :project_element_id  => element.id,
             :name => element.asset.filename,
             :title => element.asset.title,
             :mime_type => element.asset.content_type,
             :base64  => Base64.encode64(element.asset.db_file.data )
           )
       end
     end

     
     def get_content( session_id, element_id)
       setup_session(session_id)
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
     
     def set_content( session_id,folder_id, title,name, html)
       setup_session(session_id)
       ProjectElement.transaction do 
         folder = ProjectFolder.find(folder_id)
         element = folder.add_content(name,title,html)
         element.save!
         BiorailsApi::Content.new(
               :id => element.id,
               :folder_id  => element.parent_id,
               :project_element_id  => element.id,
               :name => element.name,
               :title => element.title,
               :data  =>element.to_html
               )
       end
     end

#
# get folder as html
#
protected

  def setup_session(key,project_id=nil)
    User.current          = @current_user    = User.find_by_id(key)  
    raise("Failed session key [#{key}] is invalid") unless @current_user               
    if project_id
       Project.current = @current_project = @current_user.project(project_id)
       raise "No project [#{project_id}] visible for #{@current_user.login}" unless @current_project 
    end
    return @current_user
  end


end
