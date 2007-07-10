CREATE TABLE `analysis_methods` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `class_name` varchar(255) NOT NULL,
  `protocol_version_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `analysis_settings` (
  `id` int(11) NOT NULL auto_increment,
  `analysis_method_id` int(11) default NULL,
  `name` varchar(62) default NULL,
  `script_body` text,
  `options` text,
  `parameter_id` int(11) default NULL,
  `data_type_id` int(11) default NULL,
  `level_no` int(11) default NULL,
  `column_no` int(11) default NULL,
  `mode` int(11) default NULL,
  `mandatory` varchar(255) default 'N',
  `default_value` varchar(255) default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `audits` (
  `id` int(11) NOT NULL auto_increment,
  `auditable_id` int(11) default NULL,
  `auditable_type` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `user_type` varchar(255) default NULL,
  `session` varchar(255) default NULL,
  `action` varchar(255) default NULL,
  `changes` text,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `auditable_index` (`auditable_id`,`auditable_type`),
  KEY `user_index` (`user_id`,`user_type`),
  KEY `audits_created_at_index` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `authentication_systems` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  `description` text,
  `type` varchar(255) NOT NULL default 'DataConcept',
  `host` varchar(60) default NULL,
  `port` int(11) default NULL,
  `account` varchar(60) default NULL,
  `account_password` varchar(60) default NULL,
  `base_dn` varchar(255) default NULL,
  `attr_login` varchar(30) default NULL,
  `attr_firstname` varchar(30) default NULL,
  `attr_lastname` varchar(30) default NULL,
  `attr_mail` varchar(30) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `batches` (
  `id` int(11) NOT NULL auto_increment,
  `compound_id` int(11) NOT NULL default '0',
  `name` varchar(255) default NULL,
  `description` text,
  `external_ref` varchar(255) default NULL,
  `quantity_unit` varchar(255) default NULL,
  `quantity_value` float default NULL,
  `url` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL default '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL default '0000-00-00 00:00:00',
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `batches_compound_fk` (`compound_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `catalog_logs` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `auditable_id` int(11) default NULL,
  `auditable_type` varchar(255) default NULL,
  `action` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `comment` varchar(255) default NULL,
  `created_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `catalog_logs_user_id_index` (`user_id`),
  KEY `catalog_logs_auditable_type_index` (`auditable_type`,`auditable_id`),
  KEY `catalog_logs_created_at_index` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `compounds` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  `description` text,
  `formula` varchar(50) default NULL,
  `mass` float default NULL,
  `smiles` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `registration_date` datetime default NULL,
  `iupacname` varchar(255) default '',
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `container_items` (
  `id` int(11) NOT NULL auto_increment,
  `container_group_id` int(11) NOT NULL,
  `subject_type` varchar(255) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `slot_no` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `containers` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `plate_format_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `data_concepts` (
  `id` int(11) NOT NULL auto_increment,
  `parent_id` int(11) default NULL,
  `name` varchar(50) NOT NULL default '',
  `data_context_id` int(11) NOT NULL default '0',
  `description` text,
  `access_control_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL default '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL default '0000-00-00 00:00:00',
  `type` varchar(255) NOT NULL default 'DataConcept',
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `data_concepts_idx2` (`updated_at`),
  KEY `data_concepts_idx4` (`created_at`),
  KEY `data_concepts_name_idx` (`name`),
  KEY `data_concepts_acl_idx` (`access_control_id`),
  KEY `data_concepts_fk1` (`data_context_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `data_contexts` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  `description` text,
  `access_control_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `data_contexts_idx2` (`updated_at`),
  KEY `data_contexts_idx4` (`created_at`),
  KEY `data_contexts_name_idx` (`name`),
  KEY `data_contexts_acl_idx` (`access_control_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `data_elements` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  `description` text,
  `data_system_id` int(11) NOT NULL,
  `data_concept_id` int(11) NOT NULL,
  `access_control_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `parent_id` int(10) unsigned default NULL,
  `style` varchar(10) NOT NULL,
  `content` text NOT NULL,
  `estimated_count` int(11) default NULL,
  `type` varchar(255) default NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `data_elements_idx2` (`updated_at`),
  KEY `data_elements_idx4` (`created_at`),
  KEY `data_elements_name_idx` (`name`),
  KEY `data_elements_acl_idx` (`access_control_id`),
  KEY `data_element_fk2` (`data_concept_id`),
  KEY `data_element_fk1` (`data_system_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `data_formats` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `default_value` varchar(255) default NULL,
  `format_regex` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `data_type_id` int(11) default NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  `format_sprintf` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `data_relations` (
  `id` int(11) NOT NULL auto_increment,
  `from_concept_id` int(32) NOT NULL,
  `to_concept_id` int(32) NOT NULL,
  `role_concept_id` int(32) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `data_relations_from_idx` (`from_concept_id`),
  KEY `data_relations_to_idx` (`to_concept_id`),
  KEY `data_relations_role_idx` (`role_concept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `data_systems` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  `description` text,
  `data_context_id` int(11) NOT NULL default '1',
  `access_control_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `adapter` varchar(50) NOT NULL default 'mysql',
  `host` varchar(50) default 'localhost',
  `username` varchar(50) default 'root',
  `password` varchar(50) default '',
  `database` varchar(50) default '',
  `test_object` varchar(45) NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `data_environments_idx2` (`updated_at`),
  KEY `data_environments_idx4` (`created_at`),
  KEY `data_environments_name_idx` (`name`),
  KEY `data_environments_acl_idx` (`access_control_id`),
  KEY `data_environments_fk1` (`data_context_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `data_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `value_class` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `db_files` (
  `id` int(11) NOT NULL auto_increment,
  `data` longblob,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `experiment_logs` (
  `id` int(11) NOT NULL auto_increment,
  `experiment_id` int(11) default NULL,
  `task_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `auditable_id` int(11) default NULL,
  `auditable_type` varchar(255) default NULL,
  `action` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `comment` varchar(255) default NULL,
  `created_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `experiment_logs_experiment_id_index` (`experiment_id`),
  KEY `experiment_logs_user_id_index` (`user_id`),
  KEY `experiment_logs_auditable_type_index` (`auditable_type`,`auditable_id`),
  KEY `experiment_logs_created_at_index` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `experiments` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `category_id` int(11) default NULL,
  `status_id` int(11) NOT NULL default '0',
  `study_id` int(11) NOT NULL,
  `protocol_version_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `study_protocol_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  `started_at` datetime default NULL,
  `ended_at` datetime default NULL,
  `expected_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `identifiers` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `prefix` varchar(255) default NULL,
  `postfix` varchar(255) default NULL,
  `mask` varchar(255) default NULL,
  `current_counter` int(11) default '0',
  `current_step` int(11) default '1',
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `list_items` (
  `id` int(11) NOT NULL auto_increment,
  `list_id` int(11) default NULL,
  `data_type` varchar(255) default NULL,
  `data_id` int(11) default NULL,
  `data_name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `lists` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` text,
  `type` varchar(255) default NULL,
  `expires_at` datetime default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `data_element_id` int(11) default NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `logging_events` (
  `id` int(11) NOT NULL auto_increment,
  `level` varchar(255) default NULL,
  `source` varchar(255) default NULL,
  `class_ref` varchar(255) default NULL,
  `id_ref` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `comments` varchar(255) default NULL,
  `data` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `memberships` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL default '0',
  `project_id` int(11) NOT NULL default '0',
  `role_id` int(11) NOT NULL default '0',
  `owner` tinyint(1) default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `parameter_contexts` (
  `id` int(11) NOT NULL auto_increment,
  `protocol_version_id` int(11) default NULL,
  `parent_id` int(11) default NULL,
  `level_no` int(11) default '0',
  `label` varchar(255) default NULL,
  `default_count` int(11) default '1',
  PRIMARY KEY  (`id`),
  KEY `parameter_contexts_process_instance_id_index` (`protocol_version_id`),
  KEY `parameter_contexts_parent_id_index` (`parent_id`),
  KEY `parameter_contexts_label_index` (`label`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `parameter_roles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `weighing` int(11) NOT NULL default '0',
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `parameter_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `weighing` int(11) NOT NULL default '0',
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `data_concept_id` int(11) default NULL,
  `data_type_id` int(11) default NULL,
  `storage_unit` varchar(255) default NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `parameters` (
  `id` int(11) NOT NULL auto_increment,
  `protocol_version_id` int(11) default NULL,
  `parameter_type_id` int(11) default NULL,
  `parameter_role_id` int(11) default NULL,
  `parameter_context_id` int(11) default NULL,
  `column_no` int(11) default NULL,
  `sequence_num` int(11) default NULL,
  `name` varchar(62) default NULL,
  `description` varchar(62) default NULL,
  `display_unit` varchar(20) default NULL,
  `data_element_id` int(11) default NULL,
  `qualifier_style` varchar(1) default NULL,
  `access_control_id` int(11) NOT NULL default '0',
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `mandatory` varchar(255) default 'N',
  `default_value` varchar(255) default NULL,
  `data_type_id` int(11) default NULL,
  `data_format_id` int(11) default NULL,
  `study_parameter_id` int(11) default NULL,
  `study_queue_id` int(11) default NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `parameters_name_index` (`name`),
  KEY `parameters_process_instance_id_index` (`protocol_version_id`),
  KEY `parameters_parameter_context_id_index` (`parameter_context_id`),
  KEY `parameters_parameter_type_id_index` (`parameter_type_id`),
  KEY `parameters_parameter_role_id_index` (`parameter_role_id`),
  KEY `parameters_updated_at_index` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL auto_increment,
  `checked` tinyint(1) NOT NULL default '0',
  `subject` varchar(255) NOT NULL default '',
  `action` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=475 DEFAULT CHARSET=latin1;

CREATE TABLE `plate_formats` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `rows` int(11) default NULL,
  `columns` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `plate_wells` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `label` varchar(255) default NULL,
  `row_no` int(11) NOT NULL default '0',
  `column_no` int(11) NOT NULL default '0',
  `slot_no` int(11) NOT NULL default '0',
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `plates` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` text,
  `external_ref` varchar(255) default NULL,
  `quantity_unit` varchar(255) default NULL,
  `quantity_value` float default NULL,
  `url` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL default '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL default '0000-00-00 00:00:00',
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `plugin_schema_info` (
  `plugin_name` varchar(255) default NULL,
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `process_definitions` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(30) NOT NULL,
  `release` varchar(5) NOT NULL,
  `description` text,
  `protocol_catagory` varchar(20) default NULL,
  `protocol_status` varchar(20) default NULL,
  `literature_ref` varchar(255) default NULL,
  `access_control_id` int(11) NOT NULL default '0',
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `process_definitions_name_index` (`name`),
  KEY `process_definitions_updated_at_index` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `process_instances` (
  `id` int(11) NOT NULL auto_increment,
  `process_definition_id` int(11) NOT NULL,
  `name` varchar(77) default NULL,
  `version` int(6) NOT NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` time default NULL,
  `updated_at` time default NULL,
  `how_to` text,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `process_instances_name_index` (`name`),
  KEY `process_instances_process_definition_id_index` (`process_definition_id`),
  KEY `process_instances_updated_at_index` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `project_assets` (
  `id` int(11) NOT NULL auto_increment,
  `project_id` int(11) default NULL,
  `title` varchar(255) default NULL,
  `parent_id` int(11) default NULL,
  `content_type` varchar(255) default NULL,
  `filename` varchar(255) default NULL,
  `thumbnail` varchar(255) default NULL,
  `size` int(11) default NULL,
  `width` int(11) default NULL,
  `height` int(11) default NULL,
  `thumbnails_count` int(11) default '0',
  `published` tinyint(1) default '0',
  `content_hash` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  `caption` mediumtext,
  `db_file_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `project_contents` (
  `id` int(11) NOT NULL auto_increment,
  `project_id` int(11) NOT NULL,
  `type` varchar(20) default NULL,
  `name` varchar(255) default NULL,
  `title` varchar(255) default NULL,
  `body` longtext,
  `body_html` longtext,
  `author_ip` varchar(100) default NULL,
  `comments_count` int(11) default '0',
  `comment_age` int(11) default '0',
  `published` tinyint(1) default '0',
  `content_hash` varchar(255) default NULL,
  `lock_timeout` datetime default NULL,
  `lock_user_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  `left_limit` int(11) default NULL,
  `right_limit` int(11) default NULL,
  `parent_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `project_elements` (
  `id` int(11) NOT NULL auto_increment,
  `parent_id` int(11) default NULL,
  `project_id` int(11) NOT NULL,
  `type` varchar(32) default 'ProjectElement',
  `position` int(11) default '1',
  `name` varchar(64) NOT NULL,
  `reference_id` int(11) default NULL,
  `reference_type` varchar(20) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  `asset_id` int(11) default NULL,
  `content_id` int(11) default NULL,
  `published_hash` varchar(255) default NULL,
  `project_elements_count` int(11) NOT NULL default '0',
  `left_limit` int(11) NOT NULL default '0',
  `right_limit` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `parent_id` (`name`,`parent_id`),
  KEY `project_id` (`project_id`),
  KEY `left_limit` (`left_limit`,`project_id`),
  KEY `right_limit` (`right_limit`,`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `projects` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(30) NOT NULL default '',
  `summary` text NOT NULL,
  `status_id` int(11) NOT NULL default '0',
  `title` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `host` varchar(255) default NULL,
  `comment_age` int(11) default NULL,
  `timezone` varchar(255) default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `started_at` datetime default NULL,
  `ended_at` datetime default NULL,
  `expected_at` datetime default NULL,
  `done_hours` float default NULL,
  `expected_hours` float default NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `protocol_versions` (
  `id` int(11) NOT NULL auto_increment,
  `study_protocol_id` int(11) default NULL,
  `name` varchar(77) default NULL,
  `version` int(6) NOT NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` time default NULL,
  `updated_at` time default NULL,
  `how_to` text,
  `report_id` int(11) default NULL,
  `analysis_id` int(11) default NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `process_instances_name_index` (`name`),
  KEY `process_instances_process_definition_id_index` (`study_protocol_id`),
  KEY `process_instances_updated_at_index` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `queue_items` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `comments` text,
  `study_queue_id` int(11) default NULL,
  `experiment_id` int(11) default NULL,
  `task_id` int(11) default NULL,
  `study_parameter_id` int(11) default NULL,
  `data_type` varchar(255) default NULL,
  `data_id` int(11) default NULL,
  `data_name` varchar(255) default NULL,
  `expected_at` datetime default NULL,
  `started_at` datetime default NULL,
  `ended_at` datetime default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `request_service_id` int(11) default NULL,
  `status_id` int(11) NOT NULL default '0',
  `priority_id` int(11) default NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  `requested_by_user_id` int(11) default '1',
  `assigned_to_user_id` int(11) default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `report_columns` (
  `id` int(11) NOT NULL auto_increment,
  `report_id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `join_model` varchar(255) default NULL,
  `label` varchar(255) default NULL,
  `action` varchar(255) default NULL,
  `filter_operation` varchar(255) default NULL,
  `filter_text` varchar(255) default NULL,
  `subject_type` varchar(255) default NULL,
  `subject_id` int(11) default NULL,
  `data_element` int(11) default NULL,
  `is_visible` tinyint(1) default '1',
  `is_filterible` tinyint(1) default '1',
  `is_sortable` tinyint(1) default '1',
  `order_num` int(11) default NULL,
  `sort_num` int(11) default NULL,
  `sort_direction` varchar(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `join_name` varchar(255) default NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `reports` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `base_model` varchar(255) default NULL,
  `custom_sql` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `style` varchar(255) default NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  `internal` tinyint(1) default NULL,
  `project_id` int(11) default NULL,
  `action` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `request_lists` (
  `id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `request_services` (
  `id` int(11) NOT NULL auto_increment,
  `request_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `expected_at` datetime default NULL,
  `started_at` datetime default NULL,
  `ended_at` datetime default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `status_id` int(11) NOT NULL default '0',
  `priority_id` int(11) default NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  `requested_by_user_id` int(11) default '1',
  `assigned_to_user_id` int(11) default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `requests` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `expected_at` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `list_id` int(11) default NULL,
  `data_element_id` int(11) default NULL,
  `status_id` int(11) NOT NULL default '0',
  `priority_id` int(11) default NULL,
  `project_id` int(11) default NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  `requested_by_user_id` int(11) default '1',
  `started_at` datetime default NULL,
  `ended_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `role_permissions` (
  `id` int(11) NOT NULL auto_increment,
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) default NULL,
  `subject` varchar(40) default NULL,
  `action` varchar(40) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_roles_permission_role_id` (`role_id`),
  KEY `fk_roles_permission_permission_id` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `parent_id` int(11) default NULL,
  `description` varchar(1024) NOT NULL,
  `default_page_id` int(11) default NULL,
  `cache` longtext,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `created_by_user_id` int(11) NOT NULL default '1',
  `updated_by_user_id` int(11) NOT NULL default '1',
  `type` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_role_parent_id` (`parent_id`),
  KEY `fk_role_default_page_id` (`default_page_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `samples` (
  `id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) NOT NULL,
  `data` longtext,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `specimens` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `weight` float default NULL,
  `sex` varchar(255) default NULL,
  `birth` datetime default NULL,
  `age` datetime default NULL,
  `taxon_domain` varchar(255) default NULL,
  `taxon_kingdom` varchar(255) default NULL,
  `taxon_phylum` varchar(255) default NULL,
  `taxon_class` varchar(255) default NULL,
  `taxon_family` varchar(255) default NULL,
  `taxon_order` varchar(255) default NULL,
  `taxon_genus` varchar(255) default NULL,
  `taxon_species` varchar(255) default NULL,
  `taxon_subspecies` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `studies` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `category_id` int(11) default NULL,
  `research_area` varchar(255) default NULL,
  `purpose` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `project_id` int(11) NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  `started_at` datetime default NULL,
  `ended_at` datetime default NULL,
  `expected_at` datetime default NULL,
  `status_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `studies_name_index` (`name`),
  KEY `studies_updated_at_index` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `study_logs` (
  `id` int(11) NOT NULL auto_increment,
  `study_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `auditable_id` int(11) default NULL,
  `auditable_type` varchar(255) default NULL,
  `action` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `comment` varchar(255) default NULL,
  `changes` text,
  `created_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `study_logs_study_id_index` (`study_id`),
  KEY `study_logs_user_id_index` (`user_id`),
  KEY `study_logs_auditable_type_index` (`auditable_type`,`auditable_id`),
  KEY `study_logs_created_at_index` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `study_parameters` (
  `id` int(11) NOT NULL auto_increment,
  `parameter_type_id` int(11) default NULL,
  `parameter_role_id` int(11) default NULL,
  `study_id` int(11) default '1',
  `name` varchar(255) default NULL,
  `default_value` varchar(255) default NULL,
  `data_element_id` int(11) default NULL,
  `data_type_id` int(11) default NULL,
  `data_format_id` int(11) default NULL,
  `description` varchar(1024) NOT NULL default '',
  `display_unit` varchar(255) default NULL,
  `created_by_user_id` int(11) NOT NULL default '1',
  `updated_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `study_parameters_study_id_index` (`study_id`),
  KEY `study_parameters_default_name_index` (`name`),
  KEY `study_parameters_parameter_type_id_index` (`parameter_type_id`),
  KEY `study_parameters_parameter_role_id_index` (`parameter_role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `study_protocols` (
  `id` int(11) NOT NULL auto_increment,
  `study_id` int(11) NOT NULL,
  `study_stage_id` int(11) NOT NULL default '1',
  `current_process_id` int(11) default NULL,
  `process_definition_id` int(11) default NULL,
  `process_style` varchar(128) NOT NULL default 'Entry',
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `literature_ref` text,
  `protocol_catagory` varchar(20) default NULL,
  `protocol_status` varchar(20) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `study_protocols_study_id_index` (`study_id`),
  KEY `study_protocols_process_instance_id_index` (`current_process_id`),
  KEY `study_protocols_process_definition_id_index` (`process_definition_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `study_queues` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `study_id` int(11) default NULL,
  `study_stage_id` int(11) default NULL,
  `study_parameter_id` int(11) default NULL,
  `study_protocol_id` int(11) default NULL,
  `status` varchar(255) NOT NULL default 'new',
  `priority` varchar(255) NOT NULL default 'normal',
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  `assigned_to_user_id` int(11) default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `study_stages` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `subscribers` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL default '0',
  `project_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `system_settings` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(30) NOT NULL default '',
  `description` varchar(255) NOT NULL default '',
  `text` varchar(255) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `taggings` (
  `id` int(11) NOT NULL auto_increment,
  `tag_id` int(11) default NULL,
  `taggable_id` int(11) default NULL,
  `taggable_type` varchar(255) default NULL,
  `created_at` timestamp NULL default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `task_contexts` (
  `id` int(11) NOT NULL auto_increment,
  `task_id` int(11) default NULL,
  `parameter_context_id` int(11) default NULL,
  `label` varchar(255) default NULL,
  `is_valid` tinyint(1) default NULL,
  `row_no` int(11) NOT NULL,
  `parent_id` int(11) default NULL,
  `sequence_no` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `task_contexts_task_id_index` (`task_id`),
  KEY `task_contexts_parameter_context_id_index` (`parameter_context_id`),
  KEY `task_contexts_row_no_index` (`row_no`),
  KEY `task_contexts_label_index` (`label`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `task_files` (
  `id` int(11) NOT NULL auto_increment,
  `task_context_id` int(11) default NULL,
  `parameter_id` int(11) default NULL,
  `data_uri` varchar(255) default NULL,
  `is_external` tinyint(1) default NULL,
  `mime_type` varchar(250) default NULL,
  `data_binary` text,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `task_id` int(11) default NULL,
  `content_type` varchar(255) default NULL,
  `parent_id` int(11) default NULL,
  `filename` varchar(255) default NULL,
  `thumbnail` varchar(255) default NULL,
  `size` int(11) default NULL,
  `width` int(11) default NULL,
  `height` int(11) default NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `task_references` (
  `id` int(11) NOT NULL auto_increment,
  `task_context_id` int(11) default NULL,
  `parameter_id` int(11) default NULL,
  `data_element_id` int(11) default NULL,
  `data_type` varchar(255) default NULL,
  `data_id` int(11) default NULL,
  `data_name` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `task_id` int(11) default NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `task_references_task_id_index` (`task_id`),
  KEY `task_references_task_context_id_index` (`task_context_id`),
  KEY `task_references_parameter_id_index` (`parameter_id`),
  KEY `task_references_updated_at_index` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `task_relations` (
  `id` int(11) NOT NULL auto_increment,
  `to_task_id` int(11) default NULL,
  `from_task_id` int(11) default NULL,
  `relation_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `task_texts` (
  `id` int(11) NOT NULL auto_increment,
  `task_context_id` int(11) default NULL,
  `parameter_id` int(11) default NULL,
  `markup_style_id` int(11) default NULL,
  `data_content` text,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `task_id` int(11) default NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `task_texts_task_id_index` (`task_id`),
  KEY `task_texts_task_context_id_index` (`task_context_id`),
  KEY `task_texts_parameter_id_index` (`parameter_id`),
  KEY `task_texts_updated_at_index` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `task_values` (
  `id` int(11) NOT NULL auto_increment,
  `task_context_id` int(11) default NULL,
  `parameter_id` int(11) default NULL,
  `data_value` double default NULL,
  `display_unit` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `task_id` int(11) default NULL,
  `storage_unit` varchar(255) default NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `task_values_task_id_index` (`task_id`),
  KEY `task_values_task_context_id_index` (`task_context_id`),
  KEY `task_values_parameter_id_index` (`parameter_id`),
  KEY `task_values_updated_at_index` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tasks` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `experiment_id` int(11) NOT NULL,
  `protocol_version_id` int(11) NOT NULL,
  `status_id` int(11) NOT NULL default '0',
  `is_milestone` tinyint(1) default NULL,
  `priority_id` int(11) default NULL,
  `started_at` datetime default NULL,
  `ended_at` datetime default NULL,
  `expected_hours` float default NULL,
  `done_hours` float default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `study_protocol_id` int(11) default NULL,
  `project_id` int(11) NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  `assigned_to_user_id` int(11) default '1',
  `expected_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `tasks_name_index` (`name`),
  KEY `tasks_experiment_id_index` (`experiment_id`),
  KEY `tasks_process_instance_id_index` (`protocol_version_id`),
  KEY `tasks_study_protocol_id_index` (`study_protocol_id`),
  KEY `tasks_start_date_index` (`started_at`),
  KEY `tasks_end_date_index` (`ended_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tmp_data` (
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `treatment_groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `study_id` int(11) default NULL,
  `experiment_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `treatment_items` (
  `id` int(11) NOT NULL auto_increment,
  `treatment_group_id` int(11) NOT NULL,
  `subject_type` varchar(255) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `sequence_order` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `user_settings` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(30) NOT NULL default '',
  `description` varchar(255) NOT NULL default '',
  `value` varchar(255) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `password_hash` varchar(40) default NULL,
  `role_id` int(11) NOT NULL,
  `password_salt` varchar(255) default NULL,
  `fullname` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `login` varchar(40) default NULL,
  `activation_code` varchar(40) default NULL,
  `state_id` int(11) default NULL,
  `activated_at` datetime default NULL,
  `token` varchar(255) default NULL,
  `token_expires_at` datetime default NULL,
  `filter` varchar(255) default NULL,
  `admin` tinyint(1) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  `created_by_user_id` int(11) NOT NULL default '1',
  `updated_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `fk_user_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `work_status` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `updated_by_user_id` int(11) NOT NULL default '1',
  `created_by_user_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO schema_info (version) VALUES (277)