

##
# This is the basic data Capture API for Biorails to allow the discovery of task and they creation
# 
class DataCaptureApi < ActionWebService::API::Base 

  class StudyRef < ActionWebService::Struct
    member :id, :int
    member :name, :string
    member :project_id, :int
  end

    class ProjectRef < ActionWebService::Struct
    member :id, :int
    member :name, :string
  end

  class ExperimentRef < ActionWebService::Struct
    member :id, :int
    member :study_id, :int
    member :project_id, :int
    member :name, :string
  end
  
  class TaskRef < ActionWebService::Struct
    member :id, :int
    member :experiment_id, :int
    member :study_id, :int
    member :process_id, :int
    member :project_id, :int
    member :name, :string
  end
  
  class ProtocolRef< ActionWebService::Struct
    member :id, :int
    member :study_id, :int
    member :name, :string
  end

  class ProcessRef < ActionWebService::Struct
    member :id, :int
    member :study_id, :int
    member :protocol_id, :int
    member :name, :string        
  end 

  class ParameterRef < ActionWebService::Struct
    member :id, :int
    member :process_id, :int
    member :name, :string        
    member :type, :string        
  end 
  
  class TaskItem < ActionWebService::Struct
     member :id , :int
     member :task_id , :int
     member :parameter_id , :int
     member :parameter_context_id , :int
     member :task_context_id, :int
     member :column_no, :int
     member :row_no, :int
     member :value , :string    
  end
  
  class TextData < ActionWebService::Struct
   member :content , :string
  end
  
  class BinaryData < ActionWebService::Struct
   member :content , :base64
  end
  
  inflect_names false

    api_method  :study_count,
                :returns => [:int]

    api_method  :study_ids,
                :returns => [[:int]]

   api_method  :study_hash,
                :returns => [[[:string]]]

 
     api_method  :get_study,
                :returns => [Study]


    api_method  :experiment_list,
                :expects => [ {:study_id => :int} ],
                :returns => [[Experiment]]
 
    api_method  :protocol_list,
                :expects => [ {:study_id => :int}],
                :returns => [[StudyProtocol]]

    api_method  :process_list,
                :expects => [ {:protocol_id => :int} ],
                :returns => [[ProtocolVersion]]

    api_method  :parameter_context_list,
                :expects => [ {:process_id => :int} ],
                :returns => [[ParameterContext]]
 
    api_method  :parameter_list,
                :expects => [ {:process_id => :int} ],
                :returns => [[Parameter]]
 
    api_method  :study_list,
                :returns => [[Study]]
    
    api_method  :task_list,
                :expects => [ {:experiment_id => :int} ],
                :returns => [[Task]]

    api_method  :task_values,
                :expects => [ {:task_id => :int}],
                :returns => [[TaskItem]]

    api_method  :task_contexts,
                :expects => [ {:task_id => :int}],
                :returns => [[TaskContext]]

    api_method :task_create,
               :expects => [{:experiment_id => :int},{:process_id => :int},{:task_name => :string} ],
               :returns => [Task]
    
    api_method :task_context_create,
               :expects => [{:task_id => :int},{:parameter_context_id => :int},{:values => [:string]} ],
               :returns => [TaskContext]

    api_method :task_context_update,
               :expects => [{:task_context_id => :int},{:values => [:string]} ],
               :returns => [TaskContext]
    
    api_method :task_export,
               :expects => [{:task_id => :int}],
               :returns => [:string]

    api_method :task_import,
               :expects => [{:experiment_id => :int},{:cvs => :string} ],
               :returns =>  [Task]
         
end

