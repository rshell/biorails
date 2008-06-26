
##
# This is the basic data Capture API for Biorails to allow the discovery of task and they creation
# 
class BiorailsApi < ActionWebService::API::Base 

  class TaskItem < ActionWebService::Struct
     member :id , :int
     member :task_id , :int
     member :parameter_id , :int
     member :parameter_context_id , :int
     member :task_context_id, :int
     member :column_no, :int
     member :row_no, :int
     member :value , :string    
     member :unit , :string    
     member :text , :string    
  end

  class Element < ActionWebService::Struct
     member :id , :int
     member :folder_id , :int
     member :name, :string
     member :path, :string
     member :style, :string
     member :icon, :string
     member :summary, :string
     member :asset_id , :int 
     member :content_id , :int  
     member :reference_id , :int  
     member :reference_type , :string 
  end

  class Content < ActionWebService::Struct
     member :id , :int
     member :folder_id , :int
     member :project_element_id , :int
     member :name, :string
     member :title, :string
     member :data , :string    
  end

  class Asset < ActionWebService::Struct
     member :id , :int
     member :folder_id , :int
     member :project_element_id , :int
     member :name, :string
     member :title, :string
     member :mime_type, :string
     member :base64 , :string    
  end
  
  inflect_names false

    api_method  :version,
                :returns => [:string]

    api_method  :login,
                :expects => [ {:username => :string},{:password =>:string} ],
                :returns => [:string]
                
    api_method  :project_list,
                :expects => [ {:session_id => :string} ],
                :returns => [[Project]]
 
    api_method  :project_element_list,
                :expects => [ {:session_id => :string},{:project_id => :int} ],
                :returns => [[Element]]

    api_method  :folder_element_list,
                :expects => [ {:session_id => :string},{:folder_id => :int} ],
                :returns => [[Element]]
  
    api_method  :project_folder_list,
                :expects => [ {:session_id => :string},{:project_id => :int} ],
                :returns => [[Element]] 

    api_method  :experiment_list,
                :expects => [ {:session_id => :string},{:assay_id => :int} ],
                :returns => [[Experiment]]
 
    api_method  :assay_protocol_list,
                :expects => [ {:session_id => :string},{:assay_id => :int}],
                :returns => [[AssayProtocol]]

    api_method  :assay_workflow_list,
                :expects => [ {:session_id => :string},{:assay_id => :int}],
                :returns => [[AssayWorkflow]]

    api_method  :protocol_version_list,
                :expects => [ {:session_id => :string},{:assay_protocol_id => :int} ],
                :returns => [[ProtocolVersion]]

    api_method  :process_instance_list,
                :expects => [ {:session_id => :string},{:project_id => :int} ],
                :returns => [[ProcessInstance]]
                
    api_method  :process_flow_list,
                :expects => [ {:session_id => :string},{:project_id => :int} ],
                :returns => [[ProcessFlow]]
                

  api_method  :process_step_list,
                :expects => [ {:session_id => :string},{:protocol_version_id => :int} ],
                :returns => [[ProcessStep]]

  
    api_method  :parameter_context_list,
                :expects => [ {:session_id => :string},{:protocol_version_id => :int} ],
                :returns => [[ParameterContext]]
 
    api_method  :parameter_list,
                :expects => [ {:session_id => :string},{:protocol_version_id => :int},{:parameter_context_id => :int} ],
                :returns => [[Parameter]]
 
    api_method  :assay_list,
                :expects => [ {:session_id => :string},{:project_id => :int} ],
                :returns => [[Assay]]
    
    api_method  :task_list,
                :expects => [ {:session_id => :string},{:experiment_id => :int} ],
                :returns => [[Task]]
              
  api_method    :task_mine_list,
                :expects => [ {:session_id => :string} ],
                :returns => [[Task]]

    api_method  :task_context_list,
                :expects => [ {:session_id => :string},{:task_id => :int} ],
                :returns => [[TaskContext]]

    api_method  :task_value_list,
                :expects => [ {:session_id => :string},{:task_id => :int} ],
                :returns => [[TaskItem]]

    api_method  :task_value_list_by_context,
                :expects => [ {:session_id => :string},{:task_id => :int},{:parameter_context_id => :int} ],
                :returns => [[TaskItem]]


    api_method :task_export,
               :expects => [ {:session_id => :string},{:task_id => :int} ],
               :returns => [:string]

    api_method :task_import,
               :expects => [{:session_id => :string},{:experiment_id => :int},{:cvs => :string} ],
               :returns =>  [Task]

    api_method :get_project,
               :expects => [ {:session_id => :string},{:project_id => :int} ],
               :returns =>  [Project]
    
    api_method :get_assay,
               :expects => [ {:session_id => :string},{:assay_id => :int} ],
               :returns =>  [Assay]

   api_method :get_assay_xml,
               :expects => [ {:session_id => :string},{:assay_id => :int} ],
               :returns =>  [:string]

    api_method :get_assay_protocol,
               :expects => [ {:session_id => :string},{:assay_protocol_id => :int} ],
               :returns =>  [AssayProtocol]

    api_method :get_assay_workflow,
               :expects => [ {:session_id => :string},{:assay_protocol_id => :int} ],
               :returns =>  [AssayWorkflow]

    api_method :get_protocol_version,
               :expects => [ {:session_id => :string},{:protocol_version_id => :int} ],
               :returns =>  [ProtocolVersion]

    api_method :get_experiment,
               :expects => [ {:session_id => :string},{:experiment_id => :int} ],
               :returns =>  [Experiment]

    api_method :get_task,
               :expects => [ {:session_id => :string},{:task_id => :int} ],
               :returns =>  [Task]

    api_method :get_task_xml,
               :expects => [ {:session_id => :string},{:task_id => :int} ],
               :returns =>  [:string]

    api_method :get_asset,
               :expects => [ {:session_id => :string},{:element_id => :int} ],
               :returns =>  [Asset]

   api_method :get_choices,
               :expects => [ {:session_id => :string},{:data_element_id => :int}, {:matches=>:string} ],
               :returns =>  [[:string]]             
  
   api_method :get_content,
               :expects => [ {:session_id => :string},{:element_id => :int} ],
               :returns =>  [Content]

   api_method :get_report,
               :expects => [ {:session_id => :string},{:report_id => :int},{:page => :int} ],
               :returns =>  [:string]

   api_method :get_report,
               :expects => [ {:session_id => :string},{:report_id => :int},{:page => :int} ],
               :returns =>  [:string]


  api_method :next_identifier,
             :expects => [ {:session_id => :string},{:name => :string}],
             :returns => [:string]

  api_method :add_experiment,
             :expects => [ {:session_id => :string},{:project_id => :int},{:protocol_version_id => :int},{:name => :string},{:description => :string} ],
             :returns => [Experiment]

  api_method :set_task_value,
               :expects => [ {:session_id => :int},{:task_context_id => :int},{:parameter_id => :int},{:data => :string} ],
               :returns => [TaskItem]

  api_method :add_task,
               :expects => [ {:session_id => :string},{:experiment_id => :int},{:protocol_version_id => :int},{:task_name => :string} ],
               :returns => [Task]
 
  api_method :add_task_context,
               :expects => [ {:session_id => :int},{:task_id => :int},{:parameter_context_id => :int} ],
               :returns => [TaskContext]


 
  api_method :set_asset,
               :expects => [ {:session_id => :string},{:folder_id => :int},{:title=>:string},{:filename=>:string},{:mime_type =>:string} , {:data =>:string} ],
               :returns =>  [Asset]

  api_method :set_content,
               :expects => [ {:session_id => :string},{:folder_id => :int},{:title=>:string},{:name=>:string}, {:html =>:string} ],
               :returns =>  [Content]
         
end

