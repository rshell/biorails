##
# Big migration for change over of audit columns
# basically changes created_by and updated_by to refernece to users
# eg. created_by_user_id and updated_by_user_id
# 
#
class UpgradeAuditingColumns < ActiveRecord::Migration
  def self.up
      remove_column  :authentication_systems , :created_by
      remove_column  :batches , :created_by
      remove_column  :compounds , :created_by
      remove_column  :containers , :created_by
      remove_column  :data_concepts , :created_by
      remove_column  :data_contexts , :created_by
      remove_column  :data_elements , :created_by
      remove_column  :data_formats , :created_by
      remove_column  :data_systems , :created_by
      remove_column  :data_types , :created_by
      remove_column  :experiments , :created_by
      remove_column  :identifiers , :created_by
      remove_column  :lists , :created_by
      remove_column  :memberships , :created_by
      remove_column  :parameter_roles , :created_by
      remove_column  :parameter_types , :created_by
      remove_column  :parameters , :created_by
      remove_column  :plate_formats , :created_by
      remove_column  :plate_wells , :created_by
      remove_column  :plates , :created_by
      remove_column  :process_definitions , :created_by
      remove_column  :process_instances , :created_by
      remove_column  :project_assets , :created_by
      remove_column  :project_contents , :created_by
      remove_column  :project_elements , :created_by
      remove_column  :projects , :created_by
      remove_column  :protocol_versions , :created_by
      remove_column  :queue_items , :created_by
      remove_column  :report_columns , :created_by
      remove_column  :reports , :created_by
      remove_column  :request_services , :created_by
      remove_column  :requests , :created_by
      remove_column  :specimens , :created_by
      remove_column  :studies , :created_by
      remove_column  :study_protocols , :created_by
      remove_column  :study_queues , :created_by
      remove_column  :study_stages , :created_by
      remove_column  :system_settings , :created_by
      remove_column  :task_files , :created_by
      remove_column  :task_references , :created_by
      remove_column  :task_texts , :created_by
      remove_column  :task_values , :created_by
      remove_column  :tasks , :created_by
      remove_column  :treatment_groups , :created_by
      remove_column  :user_settings , :created_by
      remove_column  :work_status , :created_by
      
      remove_column  :authentication_systems , :updated_by
      remove_column  :batches , :updated_by
      remove_column  :compounds , :updated_by
      remove_column  :containers , :updated_by
      remove_column  :data_concepts , :updated_by
      remove_column  :data_contexts , :updated_by
      remove_column  :data_elements , :updated_by
      remove_column  :data_formats , :updated_by
      remove_column  :data_systems , :updated_by
      remove_column  :data_types , :updated_by
      remove_column  :experiments , :updated_by
      remove_column  :identifiers , :updated_by
      remove_column  :lists , :updated_by
      remove_column  :memberships , :updated_by
      remove_column  :parameter_roles , :updated_by
      remove_column  :parameter_types , :updated_by
      remove_column  :parameters , :updated_by
      remove_column  :plate_formats , :updated_by
      remove_column  :plate_wells , :updated_by
      remove_column  :plates , :updated_by
      remove_column  :process_definitions , :updated_by
      remove_column  :process_instances , :updated_by
      remove_column  :project_assets , :updated_by
      remove_column  :project_contents , :updated_by
      remove_column  :project_elements , :updated_by
      remove_column  :projects , :updated_by
      remove_column  :protocol_versions , :updated_by
      remove_column  :queue_items , :updated_by
      remove_column  :report_columns , :updated_by
      remove_column  :reports , :updated_by
      remove_column  :request_services , :updated_by
      remove_column  :requests , :updated_by
      remove_column  :specimens , :updated_by
      remove_column  :studies , :updated_by
      remove_column  :study_protocols , :updated_by
      remove_column  :study_queues , :updated_by
      remove_column  :study_stages , :updated_by
      remove_column  :system_settings , :updated_by
      remove_column  :task_files , :updated_by
      remove_column  :task_references , :updated_by
      remove_column  :task_texts , :updated_by
      remove_column  :task_values , :updated_by
      remove_column  :tasks , :updated_by
      remove_column  :treatment_groups , :updated_by
      remove_column  :user_settings , :updated_by
      remove_column  :work_status , :updated_by

      add_column   :authentication_systems , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :batches , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :compounds , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :containers , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :data_concepts , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :data_contexts , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :data_elements , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :data_formats , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :data_systems , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :data_types , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :experiments , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :identifiers , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :lists , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :memberships , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :parameter_roles , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :parameter_types , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :parameters , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :plate_formats , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :plate_wells , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :plates , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :process_definitions , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :process_instances , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :project_assets , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :project_contents , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :project_elements , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :projects , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :protocol_versions , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :queue_items , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :report_columns , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :reports , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :request_services , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :requests , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :specimens , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :studies , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :study_protocols , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :study_queues , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :study_stages , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :system_settings , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :task_files , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :task_references , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :task_texts , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :task_values , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :tasks , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :treatment_groups , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :user_settings , :updated_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :work_status , :updated_by_user_id,  :integer,  :default=>1,  :null=>false

      add_column   :authentication_systems , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :batches , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :compounds , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :containers , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :data_concepts , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :data_contexts , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :data_elements , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :data_formats , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :data_systems , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :data_types , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :experiments , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :identifiers , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :lists , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :memberships , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :parameter_roles , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :parameter_types , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :parameters , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :plate_formats , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :plate_wells , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :plates , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :process_definitions , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :process_instances , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :project_assets , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :project_contents , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :project_elements , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :projects , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :protocol_versions , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :queue_items , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :report_columns , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :reports , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :request_services , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :requests , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :specimens , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :studies , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :study_protocols , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :study_queues , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :study_stages , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :system_settings , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :task_files , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :task_references , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :task_texts , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :task_values , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :tasks , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :treatment_groups , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :user_settings , :created_by_user_id,  :integer,  :default=>1,  :null=>false
      add_column   :work_status , :created_by_user_id,  :integer,  :default=>1,  :null=>false

  end

  def self.down
      add_column   :authentication_systems , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :batches , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :compounds , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :containers , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :data_concepts , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :data_contexts , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :data_elements , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :data_formats , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :data_systems , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :data_types , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :experiments , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :identifiers , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :lists , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :memberships , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :parameter_roles , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :parameter_types , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :parameters , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :plate_formats , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :plate_wells , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :plates , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :process_definitions , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :process_instances , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :project_assets , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :project_contents , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :project_elements , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :projects , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :protocol_versions , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :queue_items , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :report_columns , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :reports , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :request_services , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :requests , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :specimens , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :studies , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :study_protocols , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :study_queues , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :study_stages , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :system_settings , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :task_files , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :task_references , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :task_result_texts , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :task_result_values , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :task_results , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :task_texts , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :task_values , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :tasks , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :treatment_groups , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :user_settings , :created_by,  :string,  :default=>'guest',  :null=>false
      add_column   :work_status , :created_by,  :string,  :default=>'guest',  :null=>false
      
      add_column   :authentication_systems , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :batches , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :compounds , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :containers , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :data_concepts , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :data_contexts , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :data_elements , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :data_formats , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :data_systems , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :data_types , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :experiments , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :identifiers , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :lists , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :memberships , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :parameter_roles , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :parameter_types , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :parameters , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :plate_formats , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :plate_wells , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :plates , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :process_definitions , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :process_instances , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :project_assets , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :project_contents , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :project_elements , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :projects , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :protocol_versions , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :queue_items , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :report_columns , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :reports , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :request_services , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :requests , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :specimens , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :studies , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :study_protocols , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :study_queues , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :study_stages , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :system_settings , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :task_files , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :task_references , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :task_texts , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :task_values , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :tasks , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :treatment_groups , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :user_settings , :updated_by,  :string,  :default=>'guest',  :null=>false
      add_column   :work_status , :updated_by,  :string,  :default=>'guest',  :null=>false

        remove_column   :authentication_systems , :created_by_user_id
        remove_column   :batches , :created_by_user_id
        remove_column   :compounds , :created_by_user_id
        remove_column   :containers , :created_by_user_id
        remove_column   :data_concepts , :created_by_user_id
        remove_column   :data_contexts , :created_by_user_id
        remove_column   :data_elements , :created_by_user_id
        remove_column   :data_formats , :created_by_user_id
        remove_column   :data_systems , :created_by_user_id
        remove_column   :data_types , :created_by_user_id
        remove_column   :experiments , :created_by_user_id
        remove_column   :identifiers , :created_by_user_id
        remove_column   :lists , :created_by_user_id
        remove_column   :memberships , :created_by_user_id
        remove_column   :parameter_roles , :created_by_user_id
        remove_column   :parameter_types , :created_by_user_id
        remove_column   :parameters , :created_by_user_id
        remove_column   :plate_formats , :created_by_user_id
        remove_column   :plate_wells , :created_by_user_id
        remove_column   :plates , :created_by_user_id
        remove_column   :process_definitions , :created_by_user_id
        remove_column   :process_instances , :created_by_user_id
        remove_column   :project_assets , :created_by_user_id
        remove_column   :project_contents , :created_by_user_id
        remove_column   :project_elements , :created_by_user_id
        remove_column   :projects , :created_by_user_id
        remove_column   :protocol_versions , :created_by_user_id
        remove_column   :queue_items , :created_by_user_id
        remove_column   :report_columns , :created_by_user_id
        remove_column   :reports , :created_by_user_id
        remove_column   :request_services , :created_by_user_id
        remove_column   :requests , :created_by_user_id
        remove_column   :specimens , :created_by_user_id
        remove_column   :studies , :created_by_user_id
        remove_column   :study_protocols , :created_by_user_id
        remove_column   :study_queues , :created_by_user_id
        remove_column   :study_stages , :created_by_user_id
        remove_column   :system_settings , :created_by_user_id
        remove_column   :task_files , :created_by_user_id
        remove_column   :task_references , :created_by_user_id
        remove_column   :task_texts , :created_by_user_id
        remove_column   :task_values , :created_by_user_id
        remove_column   :tasks , :created_by_user_id
        remove_column   :treatment_groups , :created_by_user_id
        remove_column   :user_settings , :created_by_user_id
        remove_column   :work_status , :created_by_user_id
              
        remove_column   :authentication_systems , :updated_by_user_id
        remove_column   :batches , :updated_by_user_id
        remove_column   :compounds , :updated_by_user_id
        remove_column   :containers , :updated_by_user_id
        remove_column   :data_concepts , :updated_by_user_id
        remove_column   :data_contexts , :updated_by_user_id
        remove_column   :data_elements , :updated_by_user_id
        remove_column   :data_formats , :updated_by_user_id
        remove_column   :data_systems , :updated_by_user_id
        remove_column   :data_types , :updated_by_user_id
        remove_column   :experiments , :updated_by_user_id
        remove_column   :identifiers , :updated_by_user_id
        remove_column   :lists , :updated_by_user_id
        remove_column   :memberships , :updated_by_user_id
        remove_column   :parameter_roles , :updated_by_user_id
        remove_column   :parameter_types , :updated_by_user_id
        remove_column   :parameters , :updated_by_user_id
        remove_column   :plate_formats , :updated_by_user_id
        remove_column   :plate_wells , :updated_by_user_id
        remove_column   :plates , :updated_by_user_id
        remove_column   :process_definitions , :updated_by_user_id
        remove_column   :process_instances , :updated_by_user_id
        remove_column   :project_assets , :updated_by_user_id
        remove_column   :project_contents , :updated_by_user_id
        remove_column   :project_elements , :updated_by_user_id
        remove_column   :projects , :updated_by_user_id
        remove_column   :protocol_versions , :updated_by_user_id
        remove_column   :queue_items , :updated_by_user_id
        remove_column   :report_columns , :updated_by_user_id
        remove_column   :reports , :updated_by_user_id
        remove_column   :request_services , :updated_by_user_id
        remove_column   :requests , :updated_by_user_id
        remove_column   :specimens , :updated_by_user_id
        remove_column   :studies , :updated_by_user_id
        remove_column   :study_protocols , :updated_by_user_id
        remove_column   :study_queues , :updated_by_user_id
        remove_column   :study_stages , :updated_by_user_id
        remove_column   :system_settings , :updated_by_user_id
        remove_column   :task_files , :updated_by_user_id
        remove_column   :task_references , :updated_by_user_id
        remove_column   :task_texts , :updated_by_user_id
        remove_column   :task_values , :updated_by_user_id
        remove_column   :tasks , :updated_by_user_id
        remove_column   :treatment_groups , :updated_by_user_id
        remove_column   :user_settings , :updated_by_user_id
        remove_column   :work_status , :updated_by_user_id
    
  end
end
