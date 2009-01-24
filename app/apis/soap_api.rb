
##
# This is the basic data Capture API for Biorails to allow the discovery of task and they creation
# 
class SoapApi < ActionWebService::API::Base 
  
  class BiorailsDataImportDefinition < ActionWebService::Struct
    member :id , :int
    member :name , :string
    member :description , :string    
    member :default_folder_path,:string  #Default file polling location
    member :file_format ,:string 	#csv, pdf, xls, txt
    member :file_header_count,:int	#Number of file headers
    member :data_header_count,:int	#Number of headers in each area of data
    member :data_header_name_row,:int 	#The row number within the data header section for the name of the data
    member :data_header_name_col,:int	#The column number within the data header section for the name of the data
    member :data_areas_count,:int	#The number of data areas on the file (Optional)
    member :data_areas_across,:bool 	#If true the data areas written across the file in columns or areas of columns
    member :data_start_col,:int	        #The column in which the data area actually starts
    member :data_col_count,:int	        #The number of columns in each data
    member :data_row_count,:int 	#The number of rows in each data area
    member :data_read_across,:bool	#Read the data area columns across then down (true) or down then across (false)
    member :file_footer_count,:int 	#Number of footer rows 
  end
  
  class BiorailsStatus < ActionWebService::Struct
    member :ok,:bool
    member :class_id,:int
    member :class_name,:string
    member :messages,:string
    member :errors, [:string]       
  end

  class BiorailsPair < ActionWebService::Struct
    member :name , :string
    member :value , :string
  end

  class BiorailsDictionary < ActionWebService::Struct
    member :id , :int
    member :name , :string
    member :description , :string
  end

  class BiorailsConcept < SoapApi::BiorailsDictionary
    member :parent_id , :int, true
    member :not_used , :boolean
    member :not_implemented , :boolean
  end

  class BiorailsLookup < SoapApi::BiorailsDictionary
    member :data_concept_id , :int, false
    member :data_concept_name , :string, false
    member :data_system_id , :int, false
    member :data_system_name , :string, false
    member :summary , :string, false
    member :estimated_count , :int, false
    member :not_used , :boolean, false
  end

  class BiorailsListItem < ActionWebService::Struct
    member :id , :int
    member :data_type , :string
    member :data_id, :int
    member :data_name , :string
  end

  class BiorailsNamed < ActionWebService::Struct
    member :id , :int
    member :name , :string
    member :description , :string
    member :project_element_id, :int
  end

  class BiorailsProject < SoapApi::BiorailsNamed
    member :parent_id , :int
    member :project_type_id , :int
    member :state_id , :int
    member :errors,[:string]
  end

  class BiorailsQueueItem < ActionWebService::Struct
    member :assay_queue_id, :int
    member :request_service_id, :int
    member :state_id, :int
    member :name , :string
    member :data_type,:string
    member :data_id,:int
  end

  class BiorailsRequestService < SoapApi::BiorailsNamed
    member :project_id, :int
    member :data_element_id , :int
    member :request_service_id, :int
    member :status_id, :int
    member :items, [BiorailsQueueItem]
    member :errors,[:string]
  end

  class BiorailsRequest < SoapApi::BiorailsNamed
    member :project_id, :int
    member :data_element_id , :int
    member :status_id, :int
    member :services,[BiorailsRequestService]
    member :items, [BiorailsListItem]
    member :errors,[:string]
  end  

  class BiorailsAssayParameter < SoapApi::BiorailsNamed
    member :assay_id , :int
    member :role_name, :string
    member :display_unit, :string
    member :data_type_id , :int
    member :parameter_type_id , :int
    member :parameter_role_id , :int
    member :data_format_id , :int
    member :data_element_id , :int
  end
  
  class BiorailsAssayProtocol < SoapApi::BiorailsNamed
    member :assay_id , :int
    member :type, :string
  end

  class BiorailsAssayQueue < SoapApi::BiorailsNamed
    member :assay_id , :int
    member :assay_parameter_id,:int
  end

  class BiorailsAssay < SoapApi::BiorailsNamed
    member :project_id , :int
    member :parameters,[BiorailsAssayParameter]
    member :protocols,[BiorailsAssayProtocol]
    member :queues,[BiorailsAssayQueue]
  end

  class BiorailsAssayProcess < SoapApi::BiorailsAssayProtocol
  end

  class BiorailsAssayWorkflow < SoapApi::BiorailsAssayProtocol
  end

  class BiorailsProtocolVersion < SoapApi::BiorailsNamed
    member :assay_protocol_id , :int
    member :type, :string
  end

  class BiorailsParameter < ActionWebService::Struct
    member :id , :int
    member :name , :string
    member :description , :string
    member :protocol_version_id , :int
    member :assay_parameter_id , :int
    member :parameter_context_id , :int
  end

  class BiorailsParameterContext < ActionWebService::Struct
    member :id , :int
    member :protocol_version_id , :int
    member :label , :string
    member :default_count , :int
    member :parent_id, :int
    member :parameters,[BiorailsParameter]
  end

  class  BiorailsProcessInstance < SoapApi::BiorailsProtocolVersion
    member :contexts,[BiorailsParameterContext]
  end

  class BiorailsProcessStep < ActionWebService::Struct
    member :id , :int
    member :name , :string
    member :process_version_id , :int
    member :process_flow_id , :int
    member :process,[BiorailsProtocolVersion]
  end


  class  BiorailsProcessFlow < SoapApi::BiorailsProtocolVersion
    member :steps,[BiorailsProcessStep]
  end
  
  class BiorailsExperiment < BiorailsNamed
    member :project_id , :int
    member :state_id, :int
    member :started_at, :date
    member :expected_at, :date
    member :ended_at, :date
    member :tasks,[BiorailsNamed]
  end

  class BiorailsTaskContext < ActionWebService::Struct
    member :task_id , :int
    member :parent_id , :int
    member :parameter_context_id , :int
    member :label , :string
    member :row_no , :int
    member :sequence_no , :int
  end
  
  class BiorailsTaskItem < ActionWebService::Struct
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
    member :ok ,   :bool
    member :errors , [:string]

    def self.create(item)
        self.new(
        :id => item.id,
        :task_id => item.task_id,
        :parameter_id => item.parameter_id,
        :parameter_context_id => item.context.parameter_context_id,
        :task_context_id => item.task_context_id,
        :column_no => item.parameter.column_no,
        :row_no => item.context.row_no,
        :value  => item.value,
        :unit   => (item.respond_to?(:storage_unit) ? item.storage_unit : nil),
        :ok     => item.valid?,
        :errors => item.errors.full_messages,
        :text   => item.to_s )
    end 
  end

  class BiorailsTask < BiorailsNamed
    member :experiment_name,:string
    member :project_id , :int
    member :experiment_id , :int
    member :protocol_version_id, :int
    member :state_id, :integer
    member :started_at, :date
    member :expected_at, :date
    member :ended_at, :date
    member :process, BiorailsProcessInstance
    member :items, [BiorailsTaskItem]
  end
  
  class BiorailsElement < ActionWebService::Struct
    member :id , :int
    member :parent_id , :int
    member :type, :string
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

  class BiorailsFolder < ActionWebService::Struct
    member :id , :int
    member :parent_id , :int
    member :type, :string
    member :name, :string
    member :description, :string
    member :reference_type,:string
    member :reference_id,:int
    member :path, :string
    member :style, :string
    member :icon, :string
    member :summary, :string
    member :elements, [BiorailsElement]
  end

  
  inflect_names false
  #----------------------------------------------------------------------------------
  # Session management
  #
  api_method  :version,
    :returns => [:string]

  api_method  :login,
    :expects => [ {:username => :string},{:password =>:string} ],
    :returns => [:string]
                
  api_method  :data_concept_list,
    :expects => [ {:session_id => :string} ],
    :returns => [[BiorailsConcept]]

  api_method  :data_element_list,
    :expects => [ {:session_id => :string}, {:data_concept_id => :int} ],
    :returns => [[BiorailsLookup]]

  api_method  :data_value_list,
    :expects => [ {:session_id => :string}, {:data_element_id => :int}, {:limit => :int} ],
    :returns => [[BiorailsDictionary]]

  api_method  :data_value_like,
    :expects => [ {:session_id => :string},{:data_element_id => :int},{:text =>:string} ],
    :returns => [[BiorailsDictionary]]

  #----------------------------------------------------------------------------------
  # Project/Folders management
  #
  api_method  :project_list,
    :expects => [ {:session_id => :string} ],
    :returns => [[BiorailsNamed]]

  api_method  :project,
    :expects => [ {:session_id => :string},
                  {:project_id=> :int} ],
    :returns => [[BiorailsProject]]

  api_method  :project_element_list,
    :expects => [ {:session_id => :string},
                  {:parent_id => :int} ],
    :returns => [[BiorailsElement]]

  api_method  :project_element_matching,
    :expects => [ {:session_id => :string},
                  {:path_text =>  :string}],
    :returns => [[BiorailsElement]]

  api_method  :project_element_search,
    :expects => [ {:session_id => :string},
                  {:path_text =>  :string},
                  {:conditions => :string}],
    :returns => [[BiorailsElement]]

  api_method  :project_folder,
    :expects => [ {:session_id => :string},
                  {:project_element_id => :int} ],
    :returns => [[BiorailsFolder]]

  api_method :project_create,
    :expects => [ {:session_id => :string},
                  {:name => :string},
                  {:description => :string},
                  {:project_type_id => :int} ],
    :returns => [BiorailsStatus]

 
#----------------------------------------------------------------------------------
# Organization of assays
#
  api_method  :assay_list,
    :expects => [ {:session_id => :string},{:project_id => :int} ],
    :returns => [[BiorailsNamed]]

  api_method  :assay,
    :expects => [ {:session_id => :string},{:assay_id => :int} ],
    :returns => [[BiorailsAssay]]
#
# Pre assay details
#  
  api_method  :assay_parameter_list,
    :expects => [ {:session_id => :string},{:assay_id => :int} ],
    :returns => [[BiorailsAssayParameter]]
                
  api_method  :assay_protocol_list,
    :expects => [ {:session_id => :string},{:assay_id => :int} ],
    :returns => [[BiorailsAssayProtocol]]

  api_method  :assay_process_list,
    :expects => [ {:session_id => :string},{:assay_id => :int} ],
    :returns => [[BiorailsAssayProcess]]

  api_method  :assay_workflow_list,
    :expects => [ {:session_id => :string},{:assay_id => :int} ],
    :returns => [[BiorailsAssayWorkflow]]
 #
 # Process definitions
 #
  api_method  :process_instance_list,
    :expects => [ {:session_id => :string},
		{:project_id => :int}],
    :returns => [[BiorailsProtocolVersion]]

  api_method  :process_instance,
    :expects => [ {:session_id => :string},
		{:protocol_version_id => :int}],
    :returns => [BiorailsProcessInstance]

   api_method  :process_flow_list,
    :expects => [ {:session_id => :string},
		{:project_id => :int}],
    :returns => [[BiorailsProtocolVersion]]

  api_method  :process_flow,
    :expects => [ {:session_id => :string},
		{:protocol_version_id => :int}],
    :returns => [BiorailsProcessFlow]

#----------------------------------------------------------------------------------
# Create Protocols
# 
  api_method  :process_instance_create,
    :expects => [ {:session_id => :string},
		{:assay_process_id=> :integer},
		{:name => :string},
		{:description => :string}],
    :returns => [BiorailsStatus]
    
  api_method  :parameter_context_create,
    :expects => [ {:session_id => :string},
		{:process_context_id=> :integer},
		{:label => :string},
		{:default_rows => :integer}],
    :returns => [BiorailsStatus]
    
  api_method  :parameter_create,
    :expects => [ {:session_id => :string},
		{:parameter_context_id=> :integer},
		{:assay_parameter_id=> :integer}],
    :returns => [BiorailsStatus]
    

#----------------------------------------------------------------------------------
# Requests
#
  api_method  :request_list,
    :expects => [ {:session_id => :string},
                  {:project_id => :int}],
    :returns => [[BiorailsNamed]]

  api_method  :user_request,
    :expects => [ {:session_id => :string},
                  {:experiment_id => :int}],
    :returns => [BiorailsRequest]

  api_method  :request_create,
    :expects => [ {:session_id => :string},
		{:project_id=> :integer},
		{:name => :string},
		{:description => :string},
		{:expected_at => :date},
		{:data_element_id => :integer}],
    :returns => [BiorailsStatus]

  api_method  :request_add_service,
    :expects => [ {:session_id => :string},
		{:request_id=> :integer},
		{:assay_queue_id => :integer}],
    :returns => [BiorailsStatus]

  api_method  :request_add_item,
    :expects => [ {:session_id => :string},
		{:request_id=> :integer},
		{:name => :string}],
    :returns => [BiorailsStatus]

#----------------------------------------------------------------------------------
# Execution of assays
#
  api_method  :import_definition_save,
    :expects => [ {:session_id => :string},
		{:data=> [BiorailsDataImportDefinition]}],
    :returns => [BiorailsStatus]

  api_method  :import_definition_list,
    :expects => [ {:session_id => :string},
		{:data_import_definition_id=>:int}],
    :returns => [[BiorailsDataImportDefinition]]
    

  api_method  :experiment_list,
    :expects => [ {:session_id => :string},
                  {:project_id => :int}],
    :returns => [[BiorailsNamed]]

  api_method  :experiment,
    :expects => [ {:session_id => :string},
                  {:experiment_id => :int}],
    :returns => [BiorailsExperiment] 

  api_method  :experiment_create,
    :expects => [ {:session_id => :string},
		  {:project_id => :int},
		  {:protocol_version_id => :int},
                  {:name=>:string},
                  {:description=>:string}],
    :returns => [BiorailsStatus] 

  api_method  :task_list,
    :expects => [ {:session_id => :string},
                  {:project_id => :int}],
    :returns => [[BiorailsNamed]]

  api_method :task_import,
    :expects => [{:session_id => :string},{:experiment_id => :int},{:cvs => :string} ],
    :returns =>  [BiorailsStatus]

  api_method :task_export,
    :expects => [ {:session_id => :string},{:task_id => :int} ],
    :returns => [:string]

  api_method :task_destroy,
    :expects => [ {:session_id => :string},{:task_id => :int} ],
    :returns => [BiorailsStatus]

  api_method  :task,
    :expects => [ {:session_id => :string},
                  {:task_id => :int}],
    :returns => [[BiorailsTask]]

  api_method  :task_create,
    :expects => [ {:session_id => :string},
		{:experiment_id => :int},
		{:protocol_version_id => :int},
		{:name=>:string},
		{:description=>:string}],
    :returns => [BiorailsStatus] 
   
  api_method  :task_row_create,
    :expects => [ {:session_id => :string},
		{:task_id=> :integer},
		{:parameter_context_id => :integer}],
    :returns => [[BiorailsStatus]]

  api_method  :task_row_append,
    :expects => [ {:session_id => :string},
		{:task_id=> :integer},
		{:parent_context_id=> :integer},
		{:parameter_context_id => :integer},
		{:names => [:string] },
		{:values => [:string] }],
    :returns => [[BiorailsTaskItem]]

  api_method  :task_row_update,
    :expects => [ {:session_id => :string},
		{:task_context_id=> :integer},
		{:names => [:string] },
		{:values => [:string] }],
    :returns => [[BiorailsTaskItem]] 
  
end

