
##
# This is the basic data Capture API for Biorails to allow the discovery of task and they creation
# 
class BiorailsApi < ActionWebService::API::Base 

  class UserRole < ActionWebService::Struct
    member :id , :int, false
    member :type , :string, true
    member :name , :string, false
    member :parent_id , :int, true
    member :description , :string, false
    member :cache , :string, true
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :created_by_user_id , :int, false
    member :updated_by_user_id , :int, false
  end

  class User < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :role_id , :int, false
    member :fullname , :string, true
    member :email , :string, true
    member :login , :string, true
    member :state_id , :int, true
    member :activated_at , :datetime, true
    member :token , :string, true
    member :token_expires_at , :datetime, true
    member :filter , :string, true
    member :admin , :bool, true
    member :is_disabled , :bool, true
    member :login_failures , :int, false
    member :created_at , :datetime, true
    member :updated_at , :datetime, true
    member :deleted_at , :datetime, true
    member :created_by_user_id , :int, false
    member :updated_by_user_id , :int, false
  end

  class Identifier < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, true
    member :prefix , :string, true
    member :postfix , :string, true
    member :mask , :string, true
    member :current_counter , :int, true
    member :current_step , :int, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class RolePermission < ActionWebService::Struct
    member :id , :int, false
    member :role_id , :int, false
    member :permission_id , :int, true
    member :subject , :string, true
    member :action , :string, true
  end

  class State < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :is_default , :bool, true
    member :check_children , :bool, true
    member :level_no , :int, false
    member :position , :int, false
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class StateFlow < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, true
    member :description , :string, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class StateChange < ActionWebService::Struct
    member :id , :int, false
    member :state_flow_id , :int, false
    member :old_state_id , :int, false
    member :new_state_id , :int, false
    member :flow , :string, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class ProjectType < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :dashboard , :string, false
    member :publish_to_team_id , :int, false
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :created_by_user_id , :int, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :state_flow_id , :int, true
  end

  class ProjectRole < ActionWebService::Struct
    member :id , :int, false
    member :type , :string, true
    member :name , :string, false
    member :parent_id , :int, true
    member :description , :string, false
    member :cache , :string, true
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :created_by_user_id , :int, false
    member :updated_by_user_id , :int, false
  end

  class UserSetting < ActionWebService::Struct
    member :id , :int, false
    member :user_id , :int, true
    member :name , :string, false
    member :tip , :string, true
    member :value , :string, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class SystemSetting < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :tip , :string, true
    member :value , :string, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class AccessControlList < ActionWebService::Struct
    member :id , :int, false
    member :content_hash , :string, true
    member :team_id , :int, true
  end

  class AccessControlElement < ActionWebService::Struct
    member :id , :int, false
    member :access_control_list_id , :int, true
    member :owner_id , :int, true
    member :owner_type , :string, true
    member :role_id , :int, true
  end

  class DataContext < ActionWebService::Struct
    member :id , :int, false
    member :parent_id , :int, true
    member :name , :string, false
    member :data_context_id , :int, false
    member :description , :string, false
    member :access_control_id , :int, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :type , :string, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class DataConcept < ActionWebService::Struct
    member :id , :int, false
    member :parent_id , :int, true
    member :name , :string, false
    member :data_context_id , :int, false
    member :description , :string, false
    member :access_control_id , :int, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :type , :string, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class DataSystem < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :data_context_id , :int, false
    member :access_control_id , :int, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :test_object , :string, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class ListElement < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :data_system_id , :int, false
    member :data_concept_id , :int, false
    member :access_control_id , :int, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :parent_id , :int, true
    member :style , :string, false
    member :content , :string, true
    member :estimated_count , :int, true
    member :type , :string, true
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class ModelElement < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :data_system_id , :int, false
    member :data_concept_id , :int, false
    member :access_control_id , :int, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :parent_id , :int, true
    member :style , :string, false
    member :content , :string, true
    member :estimated_count , :int, true
    member :type , :string, true
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class SqlElement < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :data_system_id , :int, false
    member :data_concept_id , :int, false
    member :access_control_id , :int, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :parent_id , :int, true
    member :style , :string, false
    member :content , :string, true
    member :estimated_count , :int, true
    member :type , :string, true
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class ElementType < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :class_name , :string, false
    member :publish_to_team_id , :int, false
    member :created_at , :datetime, false
    member :created_by_user_id , :int, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
  end

  class DataType < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :value_class , :string, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class DataFormat < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :default_value , :string, true
    member :format_regex , :string, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :data_type_id , :int, true
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
    member :format_sprintf , :string, true
  end

  class ParameterType < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :weighing , :int, false
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :data_concept_id , :int, true
    member :data_type_id , :int, true
    member :storage_unit , :string, true
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class ParameterRole < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :weighing , :int, false
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class AssayStage < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class Team < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :status_id , :int, true
    member :public_role_id , :int, false
    member :external_role_id , :int, true
    member :email , :string, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :created_by_user_id , :int, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
  end

  class Project < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :status_id , :int, true
    member :title , :string, true
    member :email , :string, true
    member :host , :string, true
    member :comment_age , :int, true
    member :timezone , :string, true
    member :started_at , :datetime, true
    member :ended_at , :datetime, true
    member :expected_at , :datetime, true
    member :done_hours , :float, true
    member :team_id , :int, false
    member :expected_hours , :float, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
    member :project_type_id , :int, false
    member :parent_id , :int, true
    member :project_element_id , :int, true
  end

  class Membership < ActionWebService::Struct
    member :id , :int, false
    member :user_id , :int, false
    member :is_owner , :bool, true
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
    member :team_id , :int, false
  end

  class ProjectElement < ActionWebService::Struct
    member :id , :int, false
    member :type , :string, true
    member :parent_id , :int, true
    member :project_id , :int, false
    member :left_limit , :int, false
    member :right_limit , :int, false
    member :state_id , :int, false
    member :element_type_id , :int, false
    member :position , :int, true
    member :name , :string, false
    member :title , :string, true
    member :reference_id , :int, true
    member :reference_type , :string, true
    member :asset_id , :int, true
    member :content_id , :int, true
    member :project_elements_count , :int, false
    member :access_control_list_id , :int, false
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end


  class Assay < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :category_id , :int, true
    member :research_area , :string, true
    member :purpose , :string, true
    member :started_at , :datetime, true
    member :ended_at , :datetime, true
    member :expected_at , :datetime, true
    member :team_id , :int, false
    member :project_id , :int, false
    member :status_id , :int, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
    member :project_element_id , :int, true
  end

  class AssayParameter < ActionWebService::Struct
    member :id , :int, false
    member :parameter_type_id , :int, false
    member :parameter_role_id , :int, false
    member :assay_id , :int, true
    member :name , :string, false
    member :default_value , :string, true
    member :data_element_id , :int, true
    member :data_type_id , :int, false
    member :data_format_id , :int, true
    member :description , :string, false
    member :display_unit , :string, true
    member :created_by_user_id , :int, false
    member :updated_by_user_id , :int, false
    member :project_element_id , :int, true
  end

  class AssayQueue < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :assay_id , :int, false
    member :assay_stage_id , :int, true
    member :assay_parameter_id , :int, false
    member :assay_protocol_id , :int, true
    member :status , :string, false
    member :priority , :string, false
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
    member :assigned_to_user_id , :int, true
    member :project_element_id , :int, true
  end

  class AssayProtocol < ActionWebService::Struct
    member :id , :int, false
    member :assay_id , :int, false
    member :assay_stage_id , :int, false
    member :current_process_id , :int, true
    member :process_definition_id , :int, true
    member :process_style , :string, false
    member :name , :string, false
    member :description , :string, true
    member :literature_ref , :string, true
    member :protocol_catagory , :string, true
    member :protocol_status , :string, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
    member :type , :string, false
    member :project_element_id , :int, true
  end

  class AssayProcess < ActionWebService::Struct
    member :id , :int, false
    member :assay_id , :int, false
    member :assay_stage_id , :int, false
    member :current_process_id , :int, true
    member :process_definition_id , :int, true
    member :process_style , :string, false
    member :name , :string, false
    member :description , :string, true
    member :literature_ref , :string, true
    member :protocol_catagory , :string, true
    member :protocol_status , :string, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
    member :type , :string, false
    member :project_element_id , :int, true
  end

  class AssayWorkflow < ActionWebService::Struct
    member :id , :int, false
    member :assay_id , :int, false
    member :assay_stage_id , :int, false
    member :current_process_id , :int, true
    member :process_definition_id , :int, true
    member :process_style , :string, false
    member :name , :string, false
    member :description , :string, true
    member :literature_ref , :string, true
    member :protocol_catagory , :string, true
    member :protocol_status , :string, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
    member :type , :string, false
    member :project_element_id , :int, true
  end

  class ProtocolVersion < ActionWebService::Struct
    member :id , :int, false
    member :type , :string, true
    member :assay_protocol_id , :int, true
    member :name , :string, true
    member :version , :int, false
    member :lock_version , :int, false
    member :report_id , :int, true
    member :analysis_method_id , :int, true
    member :created_at , :datetime, true
    member :created_by_user_id , :int, false
    member :updated_at , :datetime, true
    member :updated_by_user_id , :int, false
    member :expected_hours , :float, false
    member :status , :string, true
    member :project_element_id , :int, true
    member :description , :string, true
  end

  class ProcessInstance < ActionWebService::Struct
    member :id , :int, false
    member :type , :string, true
    member :assay_protocol_id , :int, true
    member :name , :string, true
    member :version , :int, false
    member :lock_version , :int, false
    member :report_id , :int, true
    member :analysis_method_id , :int, true
    member :created_at , :datetime, true
    member :created_by_user_id , :int, false
    member :updated_at , :datetime, true
    member :updated_by_user_id , :int, false
    member :expected_hours , :float, false
    member :status , :string, true
    member :project_element_id , :int, true
    member :description , :string, true
  end

  class ProcessFlow < ActionWebService::Struct
    member :id , :int, false
    member :type , :string, true
    member :assay_protocol_id , :int, true
    member :name , :string, true
    member :version , :int, false
    member :lock_version , :int, false
    member :report_id , :int, true
    member :analysis_method_id , :int, true
    member :created_at , :datetime, true
    member :created_by_user_id , :int, false
    member :updated_at , :datetime, true
    member :updated_by_user_id , :int, false
    member :expected_hours , :float, false
    member :status , :string, true
    member :project_element_id , :int, true
    member :description , :string, true
  end

  class ProcessStep < ActionWebService::Struct
    member :id , :int, false
    member :process_flow_id , :int, false
    member :protocol_version_id , :int, false
    member :name , :string, true
    member :description , :string, true
    member :start_offset_hours , :float, false
    member :end_offset_hours , :float, false
    member :expected_hours , :float, false
    member :lock_version , :int, false
    member :created_at , :datetime, true
    member :created_by_user_id , :int, false
    member :updated_at , :datetime, true
    member :updated_by_user_id , :int, false
  end

  class ProcessStepLink < ActionWebService::Struct
    member :id , :int, false
    member :from_process_step_id , :int, true
    member :to_process_step_id , :int, true
    member :mandatory , :bool, true
  end

  class ParameterContext < ActionWebService::Struct
    member :id , :int, false
    member :protocol_version_id , :int, false
    member :parent_id , :int, true
    member :level_no , :int, true
    member :label , :string, true
    member :default_count , :int, true
    member :left_limit , :int, false
    member :right_limit , :int, false
    member :lock_version , :int, false
    member :created_at , :datetime, true
    member :updated_at , :datetime, true
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
    member :output_style , :string, false
  end

  class Parameter < ActionWebService::Struct
    member :id , :int, false
    member :protocol_version_id , :int, false
    member :parameter_type_id , :int, false
    member :parameter_role_id , :int, false
    member :parameter_context_id , :int, false
    member :column_no , :int, true
    member :sequence_num , :int, true
    member :name , :string, false
    member :description , :string, true
    member :display_unit , :string, true
    member :data_element_id , :int, true
    member :qualifier_style , :bool, true
    member :access_control_id , :int, false
    member :lock_version , :int, false
    member :mandatory , :string, true
    member :default_value , :string, true
    member :data_type_id , :int, false
    member :data_format_id , :int, true
    member :assay_parameter_id , :int, false
    member :assay_queue_id , :int, true
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class List < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, true
    member :type , :string, true
    member :expires_at , :datetime, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :data_element_id , :int, true
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class ListItem < ActionWebService::Struct
    member :id , :int, false
    member :list_id , :int, false
    member :data_type , :string, true
    member :data_id , :int, true
    member :data_name , :string, true
  end

  class Request < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :list_id , :int, true
    member :data_element_id , :int, true
    member :project_id , :int, true
    member :status_id , :int, true
    member :priority_id , :int, true
    member :started_at , :datetime, true
    member :ended_at , :datetime, true
    member :expected_at , :datetime, true
    member :lock_version , :int, false
    member :requested_by_user_id , :int, true
    member :created_at , :datetime, false
    member :created_by_user_id , :int, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :project_element_id , :int, true
  end

  class RequestService < ActionWebService::Struct
    member :id , :int, false
    member :request_id , :int, false
    member :service_id , :int, false
    member :name , :string, false
    member :description , :string, true
    member :expected_at , :datetime, true
    member :started_at , :datetime, true
    member :ended_at , :datetime, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :status_id , :int, true
    member :priority_id , :int, true
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
    member :requested_by_user_id , :int, true
    member :assigned_to_user_id , :int, true
    member :project_element_id , :int, true
  end

  class QueueItem < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, true
    member :comments , :string, false
    member :assay_queue_id , :int, true
    member :experiment_id , :int, true
    member :task_id , :int, true
    member :assay_parameter_id , :int, true
    member :data_type , :string, true
    member :data_id , :int, true
    member :data_name , :string, true
    member :expected_at , :datetime, true
    member :started_at , :datetime, true
    member :ended_at , :datetime, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :request_service_id , :int, true
    member :status_id , :int, true
    member :priority_id , :int, true
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
    member :requested_by_user_id , :int, true
    member :assigned_to_user_id , :int, true
    member :project_element_id , :int, true
  end

  class Report < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :base_model , :string, true
    member :custom_sql , :string, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :style , :string, true
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
    member :internal , :bool, true
    member :project_id , :int, true
    member :action , :string, true
    member :project_element_id , :int, true
  end

  class ReportColumn < ActionWebService::Struct
    member :id , :int, false
    member :report_id , :int, false
    member :name , :string, false
    member :description , :string, true
    member :join_model , :string, true
    member :label , :string, true
    member :action , :string, true
    member :filter_operation , :string, true
    member :filter_text , :string, true
    member :subject_type , :string, true
    member :subject_id , :int, true
    member :data_element , :int, true
    member :is_visible , :bool, true
    member :is_filterible , :bool, true
    member :is_sortable , :bool, true
    member :order_num , :int, true
    member :sort_num , :int, true
    member :sort_direction , :string, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :join_name , :string, true
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class Experiment < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :category_id , :int, true
    member :status_id , :int, true
    member :assay_id , :int, false
    member :protocol_version_id , :int, true
    member :assay_protocol_id , :int, true
    member :project_id , :int, false
    member :team_id , :int, false
    member :started_at , :datetime, true
    member :ended_at , :datetime, true
    member :expected_at , :datetime, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
    member :process_flow_id , :int, true
    member :project_element_id , :int, true
  end

  class Task < ActionWebService::Struct
    member :id , :int, false
    member :name , :string, false
    member :description , :string, false
    member :team_id , :int, false
    member :project_id , :int, false
    member :assay_protocol_id , :int, true
    member :experiment_id , :int, false
    member :protocol_version_id , :int, false
    member :assigned_to_user_id , :int, true
    member :is_milestone , :bool, true
    member :status_id , :int, true
    member :priority_id , :int, true
    member :started_at , :datetime, true
    member :expected_at , :datetime, true
    member :ended_at , :datetime, true
    member :expected_hours , :float, true
    member :done_hours , :float, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :created_by_user_id , :int, false
    member :updated_at , :datetime, false
    member :updated_by_user_id , :int, false
    member :parent_id , :int, true
    member :type , :string, true
    member :project_element_id , :int, true
  end

  class TaskContext < ActionWebService::Struct
    member :id , :int, false
    member :task_id , :int, false
    member :parameter_context_id , :int, false
    member :label , :string, true
    member :is_valid , :bool, true
    member :row_no , :int, false
    member :parent_id , :int, true
    member :sequence_no , :int, false
    member :left_limit , :int, false
    member :right_limit , :int, false
  end

  class TaskValue < ActionWebService::Struct
    member :id , :int, false
    member :task_context_id , :int, false
    member :parameter_id , :int, false
    member :data_value , :float, false
    member :display_unit , :string, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :task_id , :int, false
    member :storage_unit , :string, true
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class TaskText < ActionWebService::Struct
    member :id , :int, false
    member :task_context_id , :int, false
    member :parameter_id , :int, false
    member :data_content , :string, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :task_id , :int, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
  end

  class TaskReference < ActionWebService::Struct
    member :id , :int, false
    member :task_context_id , :int, false
    member :parameter_id , :int, false
    member :data_element_id , :int, true
    member :data_type , :string, false
    member :data_id , :int, false
    member :data_name , :string, true
    member :lock_version , :int, false
    member :created_at , :datetime, false
    member :updated_at , :datetime, false
    member :task_id , :int, false
    member :updated_by_user_id , :int, false
    member :created_by_user_id , :int, false
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
    member :state, :string
    member :state_id , :int
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

  api_method  :state_list,
    :expects => [ {:session_id => :string} ],
    :returns => [[State]]

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

  api_method :next_identifier,
    :expects => [{:name => :string}],
    :returns => [:string]

  api_method :add_experiment,
    :expects => [ {:session_id => :string},{:project_id => :int},{:protocol_version_id => :int},{:name => :string},{:description => :string} ],
    :returns => [Experiment]

  api_method :set_task_value,
    :expects => [ {:session_id => :string},{:task_context_id => :int},{:parameter_id => :int},{:data => :string} ],
    :returns => [TaskItem]

  api_method :add_task,
    :expects => [ {:session_id => :string},{:experiment_id => :int},{:protocol_version_id => :int},{:task_name => :string} ],
    :returns => [Task]
 
  api_method :add_task_context,
    :expects => [ {:session_id => :string},{:task_id => :int},{:parameter_context_id => :int},{:parent_id => :int} ],
    :returns => [TaskContext]
 
  api_method :set_asset,
    :expects => [ {:session_id => :string},{:folder_id => :int},{:title=>:string},{:filename=>:string},{:mime_type =>:string} , {:data =>:string} ],
    :returns =>  [Asset]

  api_method :set_content,
    :expects => [ {:session_id => :string},{:folder_id => :int},{:title=>:string},{:name=>:string}, {:html =>:string} ],
    :returns =>  [Content]
         
end

