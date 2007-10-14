

/* Alter table in Second database */
alter table `biorails2_production`.`analysis_methods` 
	add KEY `analysis_methods_idx10`(`created_by_user_id`), 
	add KEY `analysis_methods_idx2`(`name`), 
	add KEY `analysis_methods_idx5`(`protocol_version_id`), 
	add KEY `analysis_methods_idx7`(`created_at`), 
	add KEY `analysis_methods_idx8`(`updated_at`), 
	add KEY `analysis_methods_idx9`(`updated_by_user_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`analysis_settings` 
	add KEY `analysis_settings_idx13`(`created_at`), 
	add KEY `analysis_settings_idx14`(`updated_at`), 
	add KEY `analysis_settings_idx15`(`updated_by_user_id`), 
	add KEY `analysis_settings_idx16`(`created_by_user_id`), 
	add KEY `analysis_settings_idx2`(`analysis_method_id`), 
	add KEY `analysis_settings_idx3`(`name`), 
	add KEY `analysis_settings_idx6`(`parameter_id`), 
	add KEY `analysis_settings_idx7`(`data_type_id`), COMMENT='';
/* Create table in Second database */

create table `biorails2_production`.`audit_logs`(
	`id` int(11) NOT NULL  auto_increment  , 
	`auditable_id` int(11) NULL   , 
	`auditable_type` varchar(255) NULL   , 
	`user_id` int(11) NULL   , 
	`action` varchar(255) NULL   , 
	`changes` text NULL   , 
	`created_by` varchar(255) NULL   , 
	`created_at` datetime NULL   , 
	PRIMARY KEY (`id`) 
)Engine=InnoDB DEFAULT CHARSET='latin1';


/* Alter table in Second database */
alter table `biorails2_production`.`audits` 
	add KEY `audits_idx2`(`auditable_id`), 
	add KEY `audits_idx4`(`user_id`), 
	add KEY `audits_idx6`(`session_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`batches` 
	add KEY `batches_idx10`(`created_at`), 
	add KEY `batches_idx11`(`updated_at`), 
	add KEY `batches_idx12`(`updated_by_user_id`), 
	add KEY `batches_idx13`(`created_by_user_id`), 
	add KEY `batches_idx3`(`name`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`catalog_logs` 
	add KEY `catalog_logs_idx1`(`user_id`), 
	add KEY `catalog_logs_idx2`(`auditable_type`,`auditable_id`), 
	add KEY `catalog_logs_idx3`(`created_at`), 
	add KEY `catalog_logs_idx6`(`name`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`compounds` 
	change `created_by_user_id` `created_by_user_id` int(32) NOT NULL  DEFAULT '1' after `lock_version`, 
	change `created_at` `created_at` datetime NOT NULL  after `created_by_user_id`, 
	change `updated_by_user_id` `updated_by_user_id` int(32) NOT NULL  DEFAULT '1' after `created_at`, 
	change `updated_at` `updated_at` datetime NOT NULL  after `updated_by_user_id`, 
	add KEY `compounds_idx12`(`updated_by_user_id`), 
	add KEY `compounds_idx13`(`created_by_user_id`), 
	add KEY `compounds_idx2`(`name`), 
	add KEY `compounds_idx8`(`created_at`), 
	add KEY `compounds_idx9`(`updated_at`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`container_items` 
	add KEY `container_items_idx2`(`container_group_id`), 
	add KEY `container_items_idx4`(`subject_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`containers` 
	add KEY `containers_idx2`(`name`), 
	add KEY `containers_idx4`(`plate_format_id`), 
	add KEY `containers_idx6`(`created_at`), 
	add KEY `containers_idx7`(`updated_at`), 
	add KEY `containers_idx8`(`updated_by_user_id`), 
	add KEY `containers_idx9`(`created_by_user_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`data_concepts` 
	add KEY `data_concepts_fk0`(`parent_id`), 
	add KEY `data_concepts_idx11`(`updated_by_user_id`), 
	add KEY `data_concepts_idx12`(`created_by_user_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`data_contexts` 
	add column `created_by` varchar(32) NOT NULL  DEFAULT 'sys' after `lock_version`, 
	change `created_at` `created_at` datetime NOT NULL  after `created_by`, 
	add column `updated_by` varchar(32) NOT NULL  DEFAULT 'sys' after `created_at`, 
	change `updated_at` `updated_at` datetime NOT NULL  after `updated_by`, 
	drop column `updated_by_user_id`, 
	drop column `created_by_user_id`, 
	add KEY `data_contexts_idx1`(`updated_by`), 
	add KEY `data_contexts_idx3`(`created_by`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`data_elements` 
	add KEY `data_elements_idx10`(`parent_id`), 
	add KEY `data_elements_idx15`(`updated_by_user_id`), 
	add KEY `data_elements_idx16`(`created_by_user_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`data_formats` 
	add KEY `data_formats_idx10`(`updated_by_user_id`), 
	add KEY `data_formats_idx11`(`created_by_user_id`), 
	add KEY `data_formats_idx2`(`name`), 
	add KEY `data_formats_idx7`(`created_at`), 
	add KEY `data_formats_idx8`(`updated_at`), 
	add KEY `data_formats_idx9`(`data_type_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`data_systems` 
	add KEY `data_systems_idx15`(`updated_by_user_id`), 
	add KEY `data_systems_idx16`(`created_by_user_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`data_types` 
	add KEY `data_types_idx2`(`name`), 
	add KEY `data_types_idx6`(`created_at`), 
	add KEY `data_types_idx7`(`updated_at`), 
	add KEY `data_types_idx8`(`updated_by_user_id`), 
	add KEY `data_types_idx9`(`created_by_user_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`experiment_logs` 
	add KEY `experiment_logs_fk3`(`task_id`), 
	add KEY `experiment_logs_idx1`(`experiment_id`), 
	add KEY `experiment_logs_idx3`(`auditable_type`,`auditable_id`), 
	add KEY `experiment_logs_idx4`(`created_at`), 
	add KEY `experiment_logs_idx5`(`auditable_id`), 
	add KEY `experiment_logs_idx8`(`name`), 
	add KEY `experiment_logs_user_idx2`(`user_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`experiments` 
	add KEY `experiments_idx10`(`updated_at`), 
	add KEY `experiments_idx11`(`study_protocol_id`), 
	add KEY `experiments_idx12`(`project_id`), 
	add KEY `experiments_idx13`(`updated_by_user_id`), 
	add KEY `experiments_idx14`(`created_by_user_id`), 
	add KEY `experiments_idx2`(`name`), 
	add KEY `experiments_idx4`(`category_id`), 
	add KEY `experiments_idx5`(`status_id`), 
	add KEY `experiments_idx6`(`study_id`), 
	add KEY `experiments_idx7`(`protocol_version_id`), 
	add KEY `experiments_idx9`(`created_at`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`identifiers` 
	add KEY `identifiers_idx10`(`updated_at`), 
	add KEY `identifiers_idx11`(`updated_by_user_id`), 
	add KEY `identifiers_idx12`(`created_by_user_id`), 
	add KEY `identifiers_idx2`(`name`), 
	add KEY `identifiers_idx9`(`created_at`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`list_items` 
	add KEY `list_items_idx2`(`list_id`), 
	add KEY `list_items_idx4`(`data_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`lists` 
	add KEY `lists_idx10`(`updated_by_user_id`), 
	add KEY `lists_idx11`(`created_by_user_id`), 
	add KEY `lists_idx2`(`name`), 
	add KEY `lists_idx7`(`created_at`), 
	add KEY `lists_idx8`(`updated_at`), 
	add KEY `lists_idx9`(`data_element_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`memberships` 
	add KEY `memberships_idx2`(`user_id`), 
	add KEY `memberships_idx3`(`project_id`), 
	add KEY `memberships_idx4`(`role_id`), 
	add KEY `memberships_idx6`(`created_at`), 
	add KEY `memberships_idx7`(`updated_at`), 
	add KEY `memberships_idx8`(`updated_by_user_id`), 
	add KEY `memberships_idx9`(`created_by_user_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`parameter_contexts` 
	add KEY `parameter_contexts_ide1`(`protocol_version_id`), 
	add KEY `parameter_contexts_idx2`(`parent_id`), 
	add KEY `parameter_contexts_idx3`(`label`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`parameter_roles` 
	add KEY `parameter_roles_idx2`(`name`), 
	add KEY `parameter_roles_idx6`(`created_at`), 
	add KEY `parameter_roles_idx7`(`updated_at`), 
	add KEY `parameter_roles_idx8`(`updated_by_user_id`), 
	add KEY `parameter_roles_idx9`(`created_by_user_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`parameter_types` 
	add KEY `parameter_types_idx11`(`updated_by_user_id`), 
	add KEY `parameter_types_idx12`(`created_by_user_id`), 
	add KEY `parameter_types_idx2`(`name`), 
	add KEY `parameter_types_idx6`(`created_at`), 
	add KEY `parameter_types_idx7`(`updated_at`), 
	add KEY `parameter_types_idx8`(`data_concept_id`), 
	add KEY `parameter_types_idx9`(`data_type_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`parameters` 
	add KEY `parameters_idx1`(`name`), 
	add KEY `parameters_idx11`(`data_element_id`), 
	add KEY `parameters_idx13`(`access_control_id`), 
	add KEY `parameters_idx15`(`created_at`), 
	add KEY `parameters_idx19`(`data_type_id`), 
	add KEY `parameters_idx2`(`protocol_version_id`), 
	add KEY `parameters_idx20`(`data_format_id`), 
	add KEY `parameters_idx21`(`study_parameter_id`), 
	add KEY `parameters_idx22`(`study_queue_id`), 
	add KEY `parameters_idx23`(`updated_by_user_id`), 
	add KEY `parameters_idx24`(`created_by_user_id`), 
	add KEY `parameters_idx3`(`parameter_context_id`), 
	add KEY `parameters_idx4`(`parameter_type_id`), 
	add KEY `parameters_idx5`(`parameter_role_id`), 
	add KEY `parameters_idx6`(`updated_at`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`plate_formats` 
	add column `num_rows` int(11) NULL  after `description`, 
	add column `num_columns` int(11) NULL  after `num_rows`, 
	change `lock_version` `lock_version` int(11) NOT NULL  DEFAULT '0' after `num_columns`, 
	drop column `rows`, 
	drop column `columns`, 
	add KEY `plate_formats_idx10`(`created_by_user_id`), 
	add KEY `plate_formats_idx2`(`name`), 
	add KEY `plate_formats_idx7`(`created_at`), 
	add KEY `plate_formats_idx8`(`updated_at`), 
	add KEY `plate_formats_idx9`(`updated_by_user_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`plate_wells` 
	add KEY `plate_wells_idx10`(`updated_by_user_id`), 
	add KEY `plate_wells_idx11`(`created_by_user_id`), 
	add KEY `plate_wells_idx2`(`name`), 
	add KEY `plate_wells_idx8`(`created_at`), 
	add KEY `plate_wells_idx9`(`updated_at`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`plates` 
	add KEY `plates_idx10`(`updated_at`), 
	add KEY `plates_idx11`(`updated_by_user_id`), 
	add KEY `plates_idx12`(`created_by_user_id`), 
	add KEY `plates_idx2`(`name`), 
	add KEY `plates_idx9`(`created_at`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`project_assets` 
	add column `size_bytes` int(11) NULL  after `thumbnail`, 
	change `width` `width` int(11) NULL  after `size_bytes`, 
	drop column `size`, 
	add KEY `project_assets_idx15`(`created_at`), 
	add KEY `project_assets_idx16`(`updated_at`), 
	add KEY `project_assets_idx17`(`updated_by_user_id`), 
	add KEY `project_assets_idx18`(`created_by_user_id`), 
	add KEY `project_assets_idx2`(`project_id`), 
	add KEY `project_assets_idx20`(`db_file_id`), 
	add KEY `project_assets_idx4`(`parent_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`project_contents` 
	add KEY `project_contents_idx14`(`lock_user_id`), 
	add KEY `project_contents_idx16`(`created_at`), 
	add KEY `project_contents_idx17`(`updated_at`), 
	add KEY `project_contents_idx18`(`updated_by_user_id`), 
	add KEY `project_contents_idx19`(`created_by_user_id`), 
	add KEY `project_contents_idx2`(`project_id`), 
	add KEY `project_contents_idx22`(`parent_id`), 
	add KEY `project_contents_idx4`(`name`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`project_elements` 
	add KEY `project_elements_idx10`(`created_at`), 
	add KEY `project_elements_idx11`(`updated_at`), 
	add KEY `project_elements_idx12`(`updated_by_user_id`), 
	add KEY `project_elements_idx13`(`created_by_user_id`), 
	add KEY `project_elements_idx14`(`asset_id`), 
	add KEY `project_elements_idx15`(`content_id`), 
	add KEY `project_elements_idx2`(`parent_id`), 
	add KEY `project_elements_idx6`(`name`), 
	add KEY `project_elements_idx7`(`reference_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`projects` 
	add KEY `projects_idx10`(`created_at`), 
	add KEY `projects_idx11`(`updated_at`), 
	add KEY `projects_idx17`(`updated_by_user_id`), 
	add KEY `projects_idx18`(`created_by_user_id`), 
	add KEY `projects_idx2`(`name`), 
	add KEY `projects_idx4`(`status_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`protocol_versions` 
	add KEY `process_versions_idx1`(`name`), 
	add KEY `process_versions_idx2`(`study_protocol_id`), 
	add KEY `process_versions_idx3`(`updated_at`), 
	add KEY `protocol_versions_idx10`(`analysis_id`), 
	add KEY `protocol_versions_idx11`(`updated_by_user_id`), 
	add KEY `protocol_versions_idx12`(`created_by_user_id`), 
	add KEY `protocol_versions_idx6`(`created_at`), 
	add KEY `protocol_versions_idx9`(`report_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`queue_items` 
	add KEY `queue_items_idx15`(`created_at`), 
	add KEY `queue_items_idx16`(`updated_at`), 
	add KEY `queue_items_idx17`(`request_service_id`), 
	add KEY `queue_items_idx18`(`status_id`), 
	add KEY `queue_items_idx19`(`priority_id`), 
	add KEY `queue_items_idx2`(`name`), 
	add KEY `queue_items_idx20`(`updated_by_user_id`), 
	add KEY `queue_items_idx21`(`created_by_user_id`), 
	add KEY `queue_items_idx22`(`requested_by_user_id`), 
	add KEY `queue_items_idx23`(`assigned_to_user_id`), 
	add KEY `queue_items_idx4`(`study_queue_id`), 
	add KEY `queue_items_idx5`(`experiment_id`), 
	add KEY `queue_items_idx6`(`task_id`), 
	add KEY `queue_items_idx7`(`study_parameter_id`), 
	add KEY `queue_items_idx9`(`data_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`report_columns` 
	add KEY `report_columns_idx11`(`subject_id`), 
	add KEY `report_columns_idx2`(`report_id`), 
	add KEY `report_columns_idx20`(`created_at`), 
	add KEY `report_columns_idx21`(`updated_at`), 
	add KEY `report_columns_idx23`(`updated_by_user_id`), 
	add KEY `report_columns_idx24`(`created_by_user_id`), 
	add KEY `report_columns_idx3`(`name`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`reports` 
	add KEY `reports_idx10`(`updated_by_user_id`), 
	add KEY `reports_idx11`(`created_by_user_id`), 
	add KEY `reports_idx13`(`project_id`), 
	add KEY `reports_idx2`(`name`), 
	add KEY `reports_idx7`(`created_at`), 
	add KEY `reports_idx8`(`updated_at`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`request_services` 
	add KEY `request_services_idx10`(`created_at`), 
	add KEY `request_services_idx11`(`updated_at`), 
	add KEY `request_services_idx12`(`status_id`), 
	add KEY `request_services_idx13`(`priority_id`), 
	add KEY `request_services_idx14`(`updated_by_user_id`), 
	add KEY `request_services_idx15`(`created_by_user_id`), 
	add KEY `request_services_idx16`(`requested_by_user_id`), 
	add KEY `request_services_idx17`(`assigned_to_user_id`), 
	add KEY `request_services_idx2`(`request_id`), 
	add KEY `request_services_idx3`(`service_id`), 
	add KEY `request_services_idx4`(`name`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`requests` 
	add KEY `requests_idx10`(`status_id`), 
	add KEY `requests_idx11`(`priority_id`), 
	add KEY `requests_idx12`(`project_id`), 
	add KEY `requests_idx13`(`updated_by_user_id`), 
	add KEY `requests_idx14`(`created_by_user_id`), 
	add KEY `requests_idx15`(`requested_by_user_id`), 
	add KEY `requests_idx2`(`name`), 
	add KEY `requests_idx6`(`created_at`), 
	add KEY `requests_idx7`(`updated_at`), 
	add KEY `requests_idx8`(`list_id`), 
	add KEY `requests_idx9`(`data_element_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`role_permissions` 
	add KEY `roles_permission_idx1`(`role_id`), 
	add KEY `roles_permission_idx2`(`permission_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`roles` 
	change `cache` `cache` longtext NULL  after `description`, 
	drop column `default_page_id`, 
	drop key `fk_role_default_page_id`, 
	add KEY `role_parent_idx`(`parent_id`), 
	add KEY `roles_idx10`(`updated_by_user_id`), 
	add KEY `roles_idx2`(`name`), 
	add KEY `roles_idx7`(`created_at`), 
	add KEY `roles_idx8`(`updated_at`), 
	add KEY `roles_idx9`(`created_by_user_id`), COMMENT='';
/* Create table in Second database */

create table `biorails2_production`.`roles_permissions`(
	`id` int(11) NOT NULL  auto_increment  , 
	`role_id` int(11) NOT NULL   , 
	`permission_id` int(11) NOT NULL   , 
	PRIMARY KEY (`id`) , 
	KEY `fk_roles_permission_role_id`(`role_id`) , 
	KEY `fk_roles_permission_permission_id`(`permission_id`) 
)Engine=InnoDB DEFAULT CHARSET='latin1';


/* Alter table in Second database */
alter table `biorails2_production`.`sessions` 
	add KEY `sessions_idx2`(`session_id`), 
	add KEY `sessions_idx4`(`created_at`), 
	add KEY `sessions_idx5`(`updated_at`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`specimens` 
	add KEY `specimens_idx18`(`created_at`), 
	add KEY `specimens_idx19`(`updated_at`), 
	add KEY `specimens_idx2`(`name`), 
	add KEY `specimens_idx20`(`updated_by_user_id`), 
	add KEY `specimens_idx21`(`created_by_user_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`studies` 
	add KEY `studies_idx1`(`name`), 
	add KEY `studies_idx10`(`project_id`), 
	add KEY `studies_idx11`(`updated_by_user_id`), 
	add KEY `studies_idx12`(`created_by_user_id`), 
	add KEY `studies_idx16`(`status_id`), 
	add KEY `studies_idx2`(`updated_at`), 
	add KEY `studies_idx4`(`category_id`), 
	add KEY `studies_idx8`(`created_at`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`study_logs` 
	add KEY `study_logs_idx1`(`study_id`), 
	add KEY `study_logs_idx2`(`user_id`), 
	add KEY `study_logs_idx3`(`auditable_type`,`auditable_id`), 
	add KEY `study_logs_idx4`(`created_at`), 
	add KEY `study_logs_idx7`(`name`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`study_parameters` 
	add KEY `study_parameters_idx1`(`study_id`), 
	add KEY `study_parameters_idx12`(`created_by_user_id`), 
	add KEY `study_parameters_idx13`(`updated_by_user_id`), 
	add KEY `study_parameters_idx2`(`name`), 
	add KEY `study_parameters_idx3`(`parameter_type_id`), 
	add KEY `study_parameters_idx4`(`parameter_role_id`), 
	add KEY `study_parameters_idx7`(`data_element_id`), 
	add KEY `study_parameters_idx8`(`data_type_id`), 
	add KEY `study_parameters_idx9`(`data_format_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`study_protocols` 
	add KEY `study_protocols_idx1`(`study_id`), 
	add KEY `study_protocols_idx13`(`created_at`), 
	add KEY `study_protocols_idx14`(`updated_at`), 
	add KEY `study_protocols_idx15`(`updated_by_user_id`), 
	add KEY `study_protocols_idx16`(`created_by_user_id`), 
	add KEY `study_protocols_idx2`(`current_process_id`), 
	add KEY `study_protocols_idx3`(`process_definition_id`), 
	add KEY `study_protocols_idx7`(`name`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`study_queues` 
	add KEY `study_queues_idx11`(`created_at`), 
	add KEY `study_queues_idx12`(`updated_at`), 
	add KEY `study_queues_idx13`(`updated_by_user_id`), 
	add KEY `study_queues_idx14`(`created_by_user_id`), 
	add KEY `study_queues_idx15`(`assigned_to_user_id`), 
	add KEY `study_queues_idx2`(`name`), 
	add KEY `study_queues_idx4`(`study_id`), 
	add KEY `study_queues_idx5`(`study_stage_id`), 
	add KEY `study_queues_idx6`(`study_parameter_id`), 
	add KEY `study_queues_idx7`(`study_protocol_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`study_stages` 
	add KEY `study_stages_idx2`(`name`), 
	add KEY `study_stages_idx5`(`created_at`), 
	add KEY `study_stages_idx6`(`updated_at`), 
	add KEY `study_stages_idx7`(`updated_by_user_id`), 
	add KEY `study_stages_idx8`(`created_by_user_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`system_settings` 
	add KEY `system_settings_idx2`(`name`), 
	add KEY `system_settings_idx5`(`created_at`), 
	add KEY `system_settings_idx6`(`updated_at`), 
	add KEY `system_settings_idx7`(`updated_by_user_id`), 
	add KEY `system_settings_idx8`(`created_by_user_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`taggings` 
	add KEY `taggings_idx2`(`tag_id`), 
	add KEY `taggings_idx3`(`taggable_id`), 
	add KEY `taggings_idx5`(`created_at`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`tags` 
	add KEY `tags_idx2`(`name`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`task_contexts` 
	add KEY `task_contexts_idx1`(`task_id`), 
	add KEY `task_contexts_idx2`(`parameter_context_id`), 
	add KEY `task_contexts_idx3`(`row_no`), 
	add KEY `task_contexts_idx4`(`label`), 
	add KEY `task_contexts_idx5`(`is_valid`), 
	add KEY `task_contexts_idx7`(`parent_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`task_files` 
	add column `created_by` varchar(32) NOT NULL  after `lock_version`, 
	change `created_at` `created_at` datetime NOT NULL  after `created_by`, 
	add column `updated_by` varchar(32) NOT NULL  after `created_at`, 
	change `updated_at` `updated_at` datetime NOT NULL  after `updated_by`, 
	drop column `content_type`, 
	drop column `parent_id`, 
	drop column `filename`, 
	drop column `thumbnail`, 
	drop column `size`, 
	drop column `width`, 
	drop column `height`, 
	drop column `updated_by_user_id`, 
	drop column `created_by_user_id`, COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`task_references` 
	add KEY `task_references_fk4`(`data_element_id`), 
	add KEY `task_references_idx1`(`task_id`), 
	add KEY `task_references_idx12`(`updated_by_user_id`), 
	add KEY `task_references_idx13`(`created_by_user_id`), 
	add KEY `task_references_idx2`(`task_context_id`), 
	add KEY `task_references_idx3`(`parameter_id`), 
	add KEY `task_references_idx4`(`updated_at`), 
	add KEY `task_references_idx6`(`data_id`), 
	add KEY `task_references_idx9`(`created_at`), 
	drop key `task_references_parameter_id_index`, 
	drop key `task_references_task_context_id_index`, 
	drop key `task_references_task_id_index`, 
	drop key `task_references_updated_at_index`, COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`task_relations` 
	add KEY `task_relations_idx2`(`to_task_id`), 
	add KEY `task_relations_idx3`(`from_task_id`), 
	add KEY `task_relations_idx4`(`relation_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`task_texts` 
	change `data_content` `data_content` text NULL  after `parameter_id`, 
	drop column `markup_style_id`, 
	add KEY `task_texts_idx1`(`task_id`), 
	add KEY `task_texts_idx10`(`updated_by_user_id`), 
	add KEY `task_texts_idx11`(`created_by_user_id`), 
	add KEY `task_texts_idx2`(`task_context_id`), 
	add KEY `task_texts_idx3`(`parameter_id`), 
	add KEY `task_texts_idx4`(`updated_at`), 
	add KEY `task_texts_idx7`(`created_at`), 
	drop key `task_texts_parameter_id_index`, 
	drop key `task_texts_task_context_id_index`, 
	drop key `task_texts_task_id_index`, 
	drop key `task_texts_updated_at_index`, COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`task_values` 
	add KEY `task_values_idx1`(`task_id`), 
	add KEY `task_values_idx11`(`updated_by_user_id`), 
	add KEY `task_values_idx12`(`created_by_user_id`), 
	add KEY `task_values_idx2`(`task_context_id`), 
	add KEY `task_values_idx3`(`parameter_id`), 
	add KEY `task_values_idx4`(`updated_at`), 
	add KEY `task_values_idx5`(`data_value`), 
	add KEY `task_values_idx7`(`created_at`), 
	drop key `task_values_parameter_id_index`, 
	drop key `task_values_task_context_id_index`, 
	drop key `task_values_task_id_index`, 
	drop key `task_values_updated_at_index`, COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`tasks` 
	add KEY `tasks_idx1`(`name`), 
	add KEY `tasks_idx14`(`created_at`), 
	add KEY `tasks_idx15`(`updated_at`), 
	add KEY `tasks_idx17`(`project_id`), 
	add KEY `tasks_idx18`(`updated_by_user_id`), 
	add KEY `tasks_idx19`(`created_by_user_id`), 
	add KEY `tasks_idx2`(`experiment_id`), 
	add KEY `tasks_idx20`(`assigned_to_user_id`), 
	add KEY `tasks_idx3`(`protocol_version_id`), 
	add KEY `tasks_idx4`(`study_protocol_id`), 
	add KEY `tasks_idx5`(`started_at`), 
	add KEY `tasks_idx6`(`ended_at`), 
	add KEY `tasks_idx8`(`priority_id`), 
	drop key `tasks_name_index`, COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`treatment_groups` 
	add KEY `treatment_groups_idx10`(`created_by_user_id`), 
	add KEY `treatment_groups_idx2`(`name`), 
	add KEY `treatment_groups_idx4`(`study_id`), 
	add KEY `treatment_groups_idx5`(`experiment_id`), 
	add KEY `treatment_groups_idx7`(`created_at`), 
	add KEY `treatment_groups_idx8`(`updated_at`), 
	add KEY `treatment_groups_idx9`(`updated_by_user_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`treatment_items` 
	add KEY `treatment_items_idx2`(`treatment_group_id`), 
	add KEY `treatment_items_idx4`(`subject_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`user_settings` 
	add KEY `user_settings_idx2`(`name`), 
	add KEY `user_settings_idx5`(`created_at`), 
	add KEY `user_settings_idx6`(`updated_at`), 
	add KEY `user_settings_idx7`(`updated_by_user_id`), 
	add KEY `user_settings_idx8`(`created_by_user_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`users` 
	add KEY `users_idx10`(`state_id`), 
	add KEY `users_idx16`(`created_at`), 
	add KEY `users_idx17`(`updated_at`), 
	add KEY `users_idx19`(`created_by_user_id`), 
	add KEY `users_idx2`(`name`), 
	add KEY `users_idx20`(`updated_by_user_id`), COMMENT='';

/* Alter table in Second database */
alter table `biorails2_production`.`work_status` 
	add column `created_by` varchar(32) NOT NULL  after `lock_version`, 
	change `created_at` `created_at` datetime NOT NULL  after `created_by`, 
	add column `updated_by` varchar(32) NOT NULL  after `created_at`, 
	change `updated_at` `updated_at` datetime NOT NULL  after `updated_by`, 
	drop column `updated_by_user_id`, 
	drop column `created_by_user_id`, COMMENT='';

/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `analysis_methods`
ADD CONSTRAINT `analysis_methods_fk10` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `analysis_methods`
ADD CONSTRAINT `analysis_methods_fk5` 
FOREIGN KEY (`protocol_version_id`) REFERENCES `protocol_versions` (`id`);

ALTER TABLE `analysis_methods`
ADD CONSTRAINT `analysis_methods_fk9` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `analysis_settings`
ADD CONSTRAINT `analysis_settings_fk15` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `analysis_settings`
ADD CONSTRAINT `analysis_settings_fk16` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `analysis_settings`
ADD CONSTRAINT `analysis_settings_fk6` 
FOREIGN KEY (`parameter_id`) REFERENCES `parameters` (`id`);

ALTER TABLE `analysis_settings`
ADD CONSTRAINT `analysis_settings_fk7` 
FOREIGN KEY (`data_type_id`) REFERENCES `data_types` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `batches`
ADD CONSTRAINT `batches_fk12` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `batches`
ADD CONSTRAINT `batches_fk13` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `batches`
ADD CONSTRAINT `batches_fk2` 
FOREIGN KEY (`compound_id`) REFERENCES `compounds` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `containers`
ADD CONSTRAINT `containers_fk8` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `containers`
ADD CONSTRAINT `containers_fk9` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `data_concepts`
ADD CONSTRAINT `data_concepts_fk0` 
FOREIGN KEY (`parent_id`) REFERENCES `data_concepts` (`id`);

ALTER TABLE `data_concepts`
ADD CONSTRAINT `data_concepts_fk11` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `data_concepts`
ADD CONSTRAINT `data_concepts_fk12` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `data_elements`
ADD CONSTRAINT `data_elements_fk15` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `data_elements`
ADD CONSTRAINT `data_elements_fk16` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `data_elements`
ADD CONSTRAINT `data_elements_fk3` 
FOREIGN KEY (`data_concept_id`) REFERENCES `data_concepts` (`id`);

ALTER TABLE `data_elements`
ADD CONSTRAINT `data_elements_fk4` 
FOREIGN KEY (`data_system_id`) REFERENCES `data_systems` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `data_formats`
ADD CONSTRAINT `data_formats_fk10` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `data_formats`
ADD CONSTRAINT `data_formats_fk11` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `data_systems`
ADD CONSTRAINT `data_systems_fk15` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `data_systems`
ADD CONSTRAINT `data_systems_fk16` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `data_types`
ADD CONSTRAINT `data_types_fk8` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `data_types`
ADD CONSTRAINT `data_types_fk9` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `experiment_logs`
ADD CONSTRAINT `experiment_logs_fk3` 
FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `experiments`
ADD CONSTRAINT `experiments_fk11` 
FOREIGN KEY (`study_protocol_id`) REFERENCES `study_protocols` (`id`);

ALTER TABLE `experiments`
ADD CONSTRAINT `experiments_fk12` 
FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`);

ALTER TABLE `experiments`
ADD CONSTRAINT `experiments_fk13` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `experiments`
ADD CONSTRAINT `experiments_fk14` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `experiments`
ADD CONSTRAINT `experiments_fk6` 
FOREIGN KEY (`study_id`) REFERENCES `studies` (`id`);

ALTER TABLE `experiments`
ADD CONSTRAINT `experiments_fk7` 
FOREIGN KEY (`protocol_version_id`) REFERENCES `protocol_versions` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `identifiers`
ADD CONSTRAINT `identifiers_fk11` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `identifiers`
ADD CONSTRAINT `identifiers_fk12` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `list_items`
ADD CONSTRAINT `list_items_fk2` 
FOREIGN KEY (`list_id`) REFERENCES `lists` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `lists`
ADD CONSTRAINT `lists_fk10` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `lists`
ADD CONSTRAINT `lists_fk11` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `lists`
ADD CONSTRAINT `lists_fk9` 
FOREIGN KEY (`data_element_id`) REFERENCES `data_elements` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `memberships`
ADD CONSTRAINT `memberships_fk3` 
FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`);

ALTER TABLE `memberships`
ADD CONSTRAINT `memberships_fk4` 
FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

ALTER TABLE `memberships`
ADD CONSTRAINT `memberships_fk8` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `memberships`
ADD CONSTRAINT `memberships_fk9` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `parameter_contexts`
ADD CONSTRAINT `parameter_contexts_fk2` 
FOREIGN KEY (`protocol_version_id`) REFERENCES `protocol_versions` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `parameter_roles`
ADD CONSTRAINT `parameter_roles_fk8` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `parameter_roles`
ADD CONSTRAINT `parameter_roles_fk9` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `parameter_types`
ADD CONSTRAINT `parameter_types_fk11` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `parameter_types`
ADD CONSTRAINT `parameter_types_fk12` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `parameters`
ADD CONSTRAINT `parameters_fk11` 
FOREIGN KEY (`data_element_id`) REFERENCES `data_elements` (`id`);

ALTER TABLE `parameters`
ADD CONSTRAINT `parameters_fk19` 
FOREIGN KEY (`data_type_id`) REFERENCES `data_types` (`id`);

ALTER TABLE `parameters`
ADD CONSTRAINT `parameters_fk22` 
FOREIGN KEY (`study_queue_id`) REFERENCES `study_queues` (`id`);

ALTER TABLE `parameters`
ADD CONSTRAINT `parameters_fk23` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `parameters`
ADD CONSTRAINT `parameters_fk24` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `parameters`
ADD CONSTRAINT `parameters_fk2` 
FOREIGN KEY (`protocol_version_id`) REFERENCES `protocol_versions` (`id`);

ALTER TABLE `parameters`
ADD CONSTRAINT `parameters_fk3` 
FOREIGN KEY (`parameter_type_id`) REFERENCES `parameter_types` (`id`);

ALTER TABLE `parameters`
ADD CONSTRAINT `parameters_fk4` 
FOREIGN KEY (`parameter_role_id`) REFERENCES `parameter_roles` (`id`);

ALTER TABLE `parameters`
ADD CONSTRAINT `parameters_fk5` 
FOREIGN KEY (`parameter_context_id`) REFERENCES `parameter_contexts` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `plate_formats`
ADD CONSTRAINT `plate_formats_fk10` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `plate_formats`
ADD CONSTRAINT `plate_formats_fk9` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `plate_wells`
ADD CONSTRAINT `plate_wells_fk10` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `plate_wells`
ADD CONSTRAINT `plate_wells_fk11` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `plates`
ADD CONSTRAINT `plates_fk11` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `plates`
ADD CONSTRAINT `plates_fk12` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `project_assets`
ADD CONSTRAINT `project_assets_fk17` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `project_assets`
ADD CONSTRAINT `project_assets_fk18` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `project_assets`
ADD CONSTRAINT `project_assets_fk2` 
FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `project_contents`
ADD CONSTRAINT `project_contents_fk14` 
FOREIGN KEY (`lock_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `project_contents`
ADD CONSTRAINT `project_contents_fk18` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `project_contents`
ADD CONSTRAINT `project_contents_fk19` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `project_elements`
ADD CONSTRAINT `project_elements_fk12` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `project_elements`
ADD CONSTRAINT `project_elements_fk13` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `project_elements`
ADD CONSTRAINT `project_elements_fk3` 
FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `projects`
ADD CONSTRAINT `projects_fk17` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `projects`
ADD CONSTRAINT `projects_fk18` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `protocol_versions`
ADD CONSTRAINT `protocol_versions_fk11` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `protocol_versions`
ADD CONSTRAINT `protocol_versions_fk12` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `protocol_versions`
ADD CONSTRAINT `protocol_versions_fk2` 
FOREIGN KEY (`study_protocol_id`) REFERENCES `study_protocols` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `queue_items`
ADD CONSTRAINT `queue_items_fk17` 
FOREIGN KEY (`request_service_id`) REFERENCES `request_services` (`id`);

ALTER TABLE `queue_items`
ADD CONSTRAINT `queue_items_fk20` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `queue_items`
ADD CONSTRAINT `queue_items_fk21` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `queue_items`
ADD CONSTRAINT `queue_items_fk22` 
FOREIGN KEY (`requested_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `queue_items`
ADD CONSTRAINT `queue_items_fk23` 
FOREIGN KEY (`assigned_to_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `queue_items`
ADD CONSTRAINT `queue_items_fk4` 
FOREIGN KEY (`study_queue_id`) REFERENCES `study_queues` (`id`);

ALTER TABLE `queue_items`
ADD CONSTRAINT `queue_items_fk5` 
FOREIGN KEY (`experiment_id`) REFERENCES `experiments` (`id`);

ALTER TABLE `queue_items`
ADD CONSTRAINT `queue_items_fk6` 
FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`);

ALTER TABLE `queue_items`
ADD CONSTRAINT `queue_items_fk7` 
FOREIGN KEY (`study_parameter_id`) REFERENCES `study_parameters` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `report_columns`
ADD CONSTRAINT `report_columns_fk23` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `report_columns`
ADD CONSTRAINT `report_columns_fk24` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `reports`
ADD CONSTRAINT `reports_fk10` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `reports`
ADD CONSTRAINT `reports_fk11` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `request_services`
ADD CONSTRAINT `request_services_fk14` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `request_services`
ADD CONSTRAINT `request_services_fk15` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `request_services`
ADD CONSTRAINT `request_services_fk16` 
FOREIGN KEY (`requested_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `request_services`
ADD CONSTRAINT `request_services_fk17` 
FOREIGN KEY (`assigned_to_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `request_services`
ADD CONSTRAINT `request_services_fk2` 
FOREIGN KEY (`request_id`) REFERENCES `requests` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `requests`
ADD CONSTRAINT `requests_fk12` 
FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`);

ALTER TABLE `requests`
ADD CONSTRAINT `requests_fk13` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `requests`
ADD CONSTRAINT `requests_fk14` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `requests`
ADD CONSTRAINT `requests_fk15` 
FOREIGN KEY (`requested_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `requests`
ADD CONSTRAINT `requests_fk8` 
FOREIGN KEY (`list_id`) REFERENCES `lists` (`id`);

ALTER TABLE `requests`
ADD CONSTRAINT `requests_fk9` 
FOREIGN KEY (`data_element_id`) REFERENCES `data_elements` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `role_permissions`
ADD CONSTRAINT `role_permissions_fk2` 
FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `roles`
ADD CONSTRAINT `roles_fk10` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `roles`
ADD CONSTRAINT `roles_fk9` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

/* Create ForeignKey(s)in Second database */ 
USE `biorails2_production`; 

ALTER TABLE `roles_permissions`
ADD CONSTRAINT `fk_roles_permission_permission_id` 
FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `roles_permissions`
ADD CONSTRAINT `fk_roles_permission_role_id` 
FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `specimens`
ADD CONSTRAINT `specimens_fk20` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `specimens`
ADD CONSTRAINT `specimens_fk21` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `studies`
ADD CONSTRAINT `studies_fk10` 
FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`);

ALTER TABLE `studies`
ADD CONSTRAINT `studies_fk11` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `studies`
ADD CONSTRAINT `studies_fk12` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `study_logs`
ADD CONSTRAINT `study_logs_fk2` 
FOREIGN KEY (`study_id`) REFERENCES `studies` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `study_parameters`
ADD CONSTRAINT `study_parameters_fk12` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `study_parameters`
ADD CONSTRAINT `study_parameters_fk13` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `study_parameters`
ADD CONSTRAINT `study_parameters_fk2` 
FOREIGN KEY (`parameter_type_id`) REFERENCES `parameter_types` (`id`);

ALTER TABLE `study_parameters`
ADD CONSTRAINT `study_parameters_fk3` 
FOREIGN KEY (`parameter_role_id`) REFERENCES `parameter_roles` (`id`);

ALTER TABLE `study_parameters`
ADD CONSTRAINT `study_parameters_fk4` 
FOREIGN KEY (`study_id`) REFERENCES `studies` (`id`);

ALTER TABLE `study_parameters`
ADD CONSTRAINT `study_parameters_fk7` 
FOREIGN KEY (`data_element_id`) REFERENCES `data_elements` (`id`);

ALTER TABLE `study_parameters`
ADD CONSTRAINT `study_parameters_fk8` 
FOREIGN KEY (`data_type_id`) REFERENCES `data_types` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `study_protocols`
ADD CONSTRAINT `study_protocols_fk15` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `study_protocols`
ADD CONSTRAINT `study_protocols_fk16` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `study_protocols`
ADD CONSTRAINT `study_protocols_fk2` 
FOREIGN KEY (`study_id`) REFERENCES `studies` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `study_queues`
ADD CONSTRAINT `study_queues_fk13` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `study_queues`
ADD CONSTRAINT `study_queues_fk14` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `study_queues`
ADD CONSTRAINT `study_queues_fk15` 
FOREIGN KEY (`assigned_to_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `study_queues`
ADD CONSTRAINT `study_queues_fk4` 
FOREIGN KEY (`study_id`) REFERENCES `studies` (`id`);

ALTER TABLE `study_queues`
ADD CONSTRAINT `study_queues_fk6` 
FOREIGN KEY (`study_parameter_id`) REFERENCES `study_parameters` (`id`);

ALTER TABLE `study_queues`
ADD CONSTRAINT `study_queues_fk7` 
FOREIGN KEY (`study_protocol_id`) REFERENCES `study_protocols` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `study_stages`
ADD CONSTRAINT `study_stages_fk7` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `study_stages`
ADD CONSTRAINT `study_stages_fk8` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `system_settings`
ADD CONSTRAINT `system_settings_fk7` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `system_settings`
ADD CONSTRAINT `system_settings_fk8` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `task_contexts`
ADD CONSTRAINT `task_contexts_fk2` 
FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`);

ALTER TABLE `task_contexts`
ADD CONSTRAINT `task_contexts_fk3` 
FOREIGN KEY (`parameter_context_id`) REFERENCES `parameter_contexts` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `task_references`
ADD CONSTRAINT `task_references_fk11` 
FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`);

ALTER TABLE `task_references`
ADD CONSTRAINT `task_references_fk12` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `task_references`
ADD CONSTRAINT `task_references_fk13` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `task_references`
ADD CONSTRAINT `task_references_fk2` 
FOREIGN KEY (`task_context_id`) REFERENCES `task_contexts` (`id`);

ALTER TABLE `task_references`
ADD CONSTRAINT `task_references_fk3` 
FOREIGN KEY (`parameter_id`) REFERENCES `parameters` (`id`);

ALTER TABLE `task_references`
ADD CONSTRAINT `task_references_fk4` 
FOREIGN KEY (`data_element_id`) REFERENCES `data_elements` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `task_relations`
ADD CONSTRAINT `task_relations_fk2` 
FOREIGN KEY (`to_task_id`) REFERENCES `tasks` (`id`);

ALTER TABLE `task_relations`
ADD CONSTRAINT `task_relations_fk3` 
FOREIGN KEY (`from_task_id`) REFERENCES `tasks` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `task_texts`
ADD CONSTRAINT `task_texts_fk10` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `task_texts`
ADD CONSTRAINT `task_texts_fk11` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `task_texts`
ADD CONSTRAINT `task_texts_fk2` 
FOREIGN KEY (`task_context_id`) REFERENCES `task_contexts` (`id`);

ALTER TABLE `task_texts`
ADD CONSTRAINT `task_texts_fk3` 
FOREIGN KEY (`parameter_id`) REFERENCES `parameters` (`id`);

ALTER TABLE `task_texts`
ADD CONSTRAINT `task_texts_fk9` 
FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `task_values`
ADD CONSTRAINT `task_values_fk11` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `task_values`
ADD CONSTRAINT `task_values_fk12` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `task_values`
ADD CONSTRAINT `task_values_fk2` 
FOREIGN KEY (`task_context_id`) REFERENCES `task_contexts` (`id`);

ALTER TABLE `task_values`
ADD CONSTRAINT `task_values_fk3` 
FOREIGN KEY (`parameter_id`) REFERENCES `parameters` (`id`);

ALTER TABLE `task_values`
ADD CONSTRAINT `task_values_fk9` 
FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `tasks`
ADD CONSTRAINT `tasks_fk16` 
FOREIGN KEY (`study_protocol_id`) REFERENCES `study_protocols` (`id`);

ALTER TABLE `tasks`
ADD CONSTRAINT `tasks_fk17` 
FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`);

ALTER TABLE `tasks`
ADD CONSTRAINT `tasks_fk18` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `tasks`
ADD CONSTRAINT `tasks_fk19` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `tasks`
ADD CONSTRAINT `tasks_fk20` 
FOREIGN KEY (`assigned_to_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `tasks`
ADD CONSTRAINT `tasks_fk5` 
FOREIGN KEY (`protocol_version_id`) REFERENCES `protocol_versions` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `treatment_groups`
ADD CONSTRAINT `treatment_groups_fk10` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `treatment_groups`
ADD CONSTRAINT `treatment_groups_fk4` 
FOREIGN KEY (`study_id`) REFERENCES `studies` (`id`);

ALTER TABLE `treatment_groups`
ADD CONSTRAINT `treatment_groups_fk5` 
FOREIGN KEY (`experiment_id`) REFERENCES `experiments` (`id`);

ALTER TABLE `treatment_groups`
ADD CONSTRAINT `treatment_groups_fk9` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `user_settings`
ADD CONSTRAINT `user_settings_fk7` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `user_settings`
ADD CONSTRAINT `user_settings_fk8` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);


/* Alter ForeignKey(s)in Second database */
USE `biorails2_production`; 

ALTER TABLE `users`
ADD CONSTRAINT `users_fk19` 
FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `users`
ADD CONSTRAINT `users_fk20` 
FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`id`);

ALTER TABLE `users`
ADD CONSTRAINT `users_fk4` 
FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

/*  Create View in Second database  */
USE `biorails2_production`;

DELIMITER $$
DROP VIEW IF EXISTS `biorails2_production`.`queue_result_texts`$$
CREATE  VIEW `queue_result_texts` AS select `ti`.`id` AS `id`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`qi`.`id` AS `queue_item_id`,`qi`.`request_service_id` AS `request_service_id`,`qi`.`study_queue_id` AS `study_queue_id`,`p`.`parameter_context_id` AS `parameter_context_id`,`tr`.`task_context_id` AS `task_context_id`,`tr`.`parameter_id` AS `reference_parameter_id`,`tr`.`data_element_id` AS `data_element_id`,`tr`.`data_type` AS `data_type`,`tr`.`data_id` AS `data_id`,`tr`.`data_name` AS `subject`,`ti`.`parameter_id` AS `parameter_id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`p`.`name` AS `parameter_name`,`ti`.`data_content` AS `data_value`,`ti`.`created_by_user_id` AS `created_by_user_id`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by_user_id` AS `updated_by_user_id`,`ti`.`updated_at` AS `updated_at` from (((((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_references` `tr`) join `task_texts` `ti`) join `queue_items` `qi`) where ((`tc`.`id` = `tr`.`task_context_id`) and (`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`) and (`qi`.`task_id` = `tr`.`task_id`) and (`qi`.`data_id` = `tr`.`data_id`) and (`qi`.`data_type` = `tr`.`data_type`) and (`qi`.`data_name` = `tr`.`data_name`))$$
DELIMITER ;

/*  Create View in Second database  */
USE `biorails2_production`;

DELIMITER $$
DROP VIEW IF EXISTS `biorails2_production`.`queue_result_values`$$
CREATE  VIEW `queue_result_values` AS select `ti`.`id` AS `id`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`qi`.`id` AS `queue_item_id`,`qi`.`request_service_id` AS `request_service_id`,`qi`.`study_queue_id` AS `study_queue_id`,`p`.`parameter_context_id` AS `parameter_context_id`,`tr`.`task_context_id` AS `task_context_id`,`tr`.`parameter_id` AS `reference_parameter_id`,`tr`.`data_element_id` AS `data_element_id`,`tr`.`data_type` AS `data_type`,`tr`.`data_id` AS `data_id`,`tr`.`data_name` AS `subject`,`ti`.`parameter_id` AS `parameter_id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`p`.`name` AS `parameter_name`,`ti`.`data_value` AS `data_value`,`ti`.`created_by_user_id` AS `created_by_user_id`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by_user_id` AS `updated_by_user_id`,`ti`.`updated_at` AS `updated_at` from (((((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_references` `tr`) join `task_values` `ti`) join `queue_items` `qi`) where ((`tc`.`id` = `tr`.`task_context_id`) and (`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`) and (`qi`.`task_id` = `tr`.`task_id`) and (`qi`.`data_id` = `tr`.`data_id`) and (`qi`.`data_type` = `tr`.`data_type`) and (`qi`.`data_name` = `tr`.`data_name`))$$
DELIMITER ;

/*  Alter View in Second database  */
USE `biorails2_production`;

DELIMITER $$
DROP VIEW IF EXISTS `biorails2_production`.`task_results`$$

CREATE  VIEW `task_results` AS select `ti`.`id` AS `id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`id` AS `parameter_context_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`ti`.`parameter_id` AS `parameter_id`,`p`.`name` AS `parameter_name`,`ti`.`data_value` AS `data_value`,`ti`.`created_by_user_id` AS `created_by_user_id`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by_user_id` AS `updated_by_user_id`,`ti`.`updated_at` AS `updated_at` from (((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_values` `ti`) where ((`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`)) union select `ti`.`id` AS `id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`id` AS `parameter_context_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`ti`.`parameter_id` AS `parameter_id`,`p`.`name` AS `parameter_name`,`ti`.`data_content` AS `data_value`,`ti`.`created_by_user_id` AS `created_by_user_id`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by_user_id` AS `updated_by_user_id`,`ti`.`updated_at` AS `updated_at` from (((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_texts` `ti`) where ((`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`)) union select `ti`.`id` AS `id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`id` AS `parameter_context_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`ti`.`parameter_id` AS `parameter_id`,`p`.`name` AS `parameter_name`,`ti`.`data_name` AS `data_value`,`ti`.`created_by_user_id` AS `created_by_user_id`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by_user_id` AS `updated_by_user_id`,`ti`.`updated_at` AS `updated_at` from (((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_references` `ti`) where ((`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`))$$
DELIMITER ;
