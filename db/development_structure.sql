CREATE TABLE `audit_logs` (
  `id` int(11) NOT NULL auto_increment,
  `auditable_id` int(11) default NULL,
  `auditable_type` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `action` varchar(255) default NULL,
  `changes` text,
  `created_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
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
  `created_by` varchar(32) NOT NULL default 'sys',
  `created_at` datetime NOT NULL default '0000-00-00 00:00:00',
  `updated_by` varchar(32) NOT NULL default 'sys',
  `updated_at` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`),
  KEY `batches_compound_fk` (`compound_id`),
  CONSTRAINT `batches_compound_fk` FOREIGN KEY (`compound_id`) REFERENCES `compounds` (`id`) ON DELETE CASCADE
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
  `created_by` varchar(32) NOT NULL default 'sys',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default 'sys',
  `updated_at` datetime NOT NULL,
  `registration_date` datetime default NULL,
  `iupacname` varchar(255) default '',
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
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `content_pages` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `name` varchar(255) NOT NULL,
  `markup_style_id` int(11) default NULL,
  `content` text,
  `permission_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `content_cache` text,
  PRIMARY KEY  (`id`),
  KEY `fk_content_page_permission_id` (`permission_id`),
  KEY `fk_content_page_markup_style_id` (`markup_style_id`),
  CONSTRAINT `fk_content_page_markup_style_id` FOREIGN KEY (`markup_style_id`) REFERENCES `markup_styles` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_content_page_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `controller_actions` (
  `id` int(11) NOT NULL auto_increment,
  `site_controller_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `permission_id` int(11) default NULL,
  `url_to_use` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_controller_action_permission_id` (`permission_id`),
  KEY `fk_controller_action_site_controller_id` (`site_controller_id`),
  CONSTRAINT `fk_controller_action_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_controller_action_site_controller_id` FOREIGN KEY (`site_controller_id`) REFERENCES `site_controllers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `data_concepts` (
  `id` int(11) NOT NULL auto_increment,
  `parent_id` int(11) default NULL,
  `name` varchar(50) NOT NULL default '',
  `data_context_id` int(11) NOT NULL default '0',
  `description` text,
  `access_control_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default 'sys',
  `created_at` datetime NOT NULL default '0000-00-00 00:00:00',
  `updated_by` varchar(32) NOT NULL default 'sys',
  `updated_at` datetime NOT NULL default '0000-00-00 00:00:00',
  `type` varchar(255) NOT NULL default 'DataConcept',
  PRIMARY KEY  (`id`),
  KEY `data_concepts_idx1` (`updated_by`),
  KEY `data_concepts_idx2` (`updated_at`),
  KEY `data_concepts_idx3` (`created_by`),
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
  `created_by` varchar(32) NOT NULL default 'sys',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default 'sys',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `data_contexts_idx1` (`updated_by`),
  KEY `data_contexts_idx2` (`updated_at`),
  KEY `data_contexts_idx3` (`created_by`),
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
  `created_by` varchar(32) NOT NULL default 'sys',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default 'sys',
  `updated_at` datetime NOT NULL,
  `parent_id` int(10) unsigned default NULL,
  `style` varchar(10) NOT NULL,
  `content` text NOT NULL,
  `estimated_count` int(11) default NULL,
  `type` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `data_elements_idx1` (`updated_by`),
  KEY `data_elements_idx2` (`updated_at`),
  KEY `data_elements_idx3` (`created_by`),
  KEY `data_elements_idx4` (`created_at`),
  KEY `data_elements_name_idx` (`name`),
  KEY `data_elements_acl_idx` (`access_control_id`),
  KEY `data_element_fk2` (`data_concept_id`),
  KEY `data_element_fk1` (`data_system_id`),
  CONSTRAINT `data_element_fk2` FOREIGN KEY (`data_concept_id`) REFERENCES `data_concepts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `data_environments` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  `description` text,
  `data_context_id` int(11) NOT NULL default '1',
  `access_control_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default 'sys',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default 'sys',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `data_environments_idx1` (`updated_by`),
  KEY `data_environments_idx2` (`updated_at`),
  KEY `data_environments_idx3` (`created_by`),
  KEY `data_environments_idx4` (`created_at`),
  KEY `data_environments_name_idx` (`name`),
  KEY `data_environments_acl_idx` (`access_control_id`),
  KEY `data_environments_fk1` (`data_context_id`),
  CONSTRAINT `data_environments_fk1` FOREIGN KEY (`data_context_id`) REFERENCES `data_contexts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `data_formats` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `default_value` varchar(255) default NULL,
  `format_regex` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `data_type_id` int(11) default NULL,
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
  KEY `data_relations_role_idx` (`role_concept_id`),
  CONSTRAINT `data_relations_from_fk` FOREIGN KEY (`from_concept_id`) REFERENCES `data_concepts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `data_relations_role_fk` FOREIGN KEY (`role_concept_id`) REFERENCES `data_concepts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `data_relations_to_fk` FOREIGN KEY (`to_concept_id`) REFERENCES `data_concepts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `data_systems` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  `description` text,
  `data_context_id` int(11) NOT NULL default '1',
  `access_control_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default 'sys',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default 'sys',
  `updated_at` datetime NOT NULL,
  `adapter` varchar(50) NOT NULL default 'mysql',
  `host` varchar(50) default 'localhost',
  `username` varchar(50) default 'root',
  `password` varchar(50) default '',
  `database` varchar(50) default '',
  `test_object` varchar(45) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `data_environments_idx1` (`updated_by`),
  KEY `data_environments_idx2` (`updated_at`),
  KEY `data_environments_idx3` (`created_by`),
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
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dead_process_definition` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(30) NOT NULL,
  `release` varchar(5) NOT NULL,
  `description` text,
  `protocol_catagory` varchar(20) default NULL,
  `protocol_status` varchar(20) default NULL,
  `literature_ref` varchar(255) default NULL,
  `access_control_id` int(11) NOT NULL default '0',
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `process_definitions_name_index` (`name`),
  KEY `process_definitions_updated_by_index` (`updated_by`),
  KEY `process_definitions_updated_at_index` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `engine_schema_info` (
  `engine_name` varchar(255) default NULL,
  `version` int(11) default NULL
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
  `status_id` varchar(255) default NULL,
  `study_id` int(11) default NULL,
  `protocol_version_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `study_protocol_id` int(11) default NULL,
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
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `data_element_id` int(11) default NULL,
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

CREATE TABLE `markup_styles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `menu_items` (
  `id` int(11) NOT NULL auto_increment,
  `parent_id` int(11) default NULL,
  `name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `seq` int(11) default NULL,
  `controller_action_id` int(11) default NULL,
  `content_page_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_menu_item_controller_action_id` (`controller_action_id`),
  KEY `fk_menu_item_content_page_id` (`content_page_id`),
  KEY `fk_menu_item_parent_id` (`parent_id`),
  CONSTRAINT `fk_menu_item_content_page_id` FOREIGN KEY (`content_page_id`) REFERENCES `content_pages` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_menu_item_controller_action_id` FOREIGN KEY (`controller_action_id`) REFERENCES `controller_actions` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_menu_item_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `menu_items` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
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
  `created_by` varchar(32) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `parameter_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `weighing` int(11) NOT NULL default '0',
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL,
  `updated_at` datetime NOT NULL,
  `data_concept_id` int(11) default NULL,
  `data_type_id` int(11) default NULL,
  `storage_unit` varchar(255) default NULL,
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
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `mandatory` varchar(255) default 'N',
  `default_value` varchar(255) default NULL,
  `data_type_id` int(11) default NULL,
  `data_format_id` int(11) default NULL,
  `study_parameter_id` int(11) default NULL,
  `study_queue_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `parameters_name_index` (`name`),
  KEY `parameters_process_instance_id_index` (`protocol_version_id`),
  KEY `parameters_parameter_context_id_index` (`parameter_context_id`),
  KEY `parameters_parameter_type_id_index` (`parameter_type_id`),
  KEY `parameters_parameter_role_id_index` (`parameter_role_id`),
  KEY `parameters_updated_by_index` (`updated_by`),
  KEY `parameters_updated_at_index` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `plate_formats` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `rows` int(11) default NULL,
  `columns` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
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
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
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
  `created_by` varchar(32) NOT NULL default 'sys',
  `created_at` datetime NOT NULL default '0000-00-00 00:00:00',
  `updated_by` varchar(32) NOT NULL default 'sys',
  `updated_at` datetime NOT NULL default '0000-00-00 00:00:00',
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
  `created_by` varchar(32) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `process_definitions_name_index` (`name`),
  KEY `process_definitions_updated_by_index` (`updated_by`),
  KEY `process_definitions_updated_at_index` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `process_instances` (
  `id` int(11) NOT NULL auto_increment,
  `process_definition_id` int(11) NOT NULL,
  `name` varchar(77) default NULL,
  `version` int(6) NOT NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) default NULL,
  `created_at` time default NULL,
  `updated_by` varchar(32) default NULL,
  `updated_at` time default NULL,
  `how_to` text,
  PRIMARY KEY  (`id`),
  KEY `process_instances_name_index` (`name`),
  KEY `process_instances_process_definition_id_index` (`process_definition_id`),
  KEY `process_instances_updated_by_index` (`updated_by`),
  KEY `process_instances_updated_at_index` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `protocol_versions` (
  `id` int(11) NOT NULL auto_increment,
  `study_protocol_id` int(11) default NULL,
  `name` varchar(77) default NULL,
  `version` int(6) NOT NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) default NULL,
  `created_at` time default NULL,
  `updated_by` varchar(32) default NULL,
  `updated_at` time default NULL,
  `how_to` text,
  PRIMARY KEY  (`id`),
  KEY `process_instances_name_index` (`name`),
  KEY `process_instances_process_definition_id_index` (`study_protocol_id`),
  KEY `process_instances_updated_by_index` (`updated_by`),
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
  `requested_by` varchar(60) default NULL,
  `assigned_to` varchar(60) default NULL,
  `requested_for` datetime default NULL,
  `accepted_at` datetime default NULL,
  `completed_at` datetime default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `request_service_id` int(11) default NULL,
  `status_id` int(11) default NULL,
  `priority_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `report_columns` (
  `id` int(11) NOT NULL auto_increment,
  `report_id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `join_model` varchar(255) default NULL,
  `label` varchar(255) default NULL,
  `action` text,
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
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `reports` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `base_model` varchar(255) default NULL,
  `custom_sql` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
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
  `requested_by` varchar(60) default NULL,
  `requested_for` datetime default NULL,
  `assigned_to` varchar(60) default NULL,
  `accepted_at` datetime default NULL,
  `completed_at` datetime default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `status_id` int(11) default NULL,
  `priority_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `requests` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `requested_by` varchar(255) default NULL,
  `requested_for` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `list_id` int(11) default NULL,
  `data_element_id` int(11) default NULL,
  `status_id` int(11) default NULL,
  `priority_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
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
  PRIMARY KEY  (`id`),
  KEY `fk_role_parent_id` (`parent_id`),
  KEY `fk_role_default_page_id` (`default_page_id`),
  CONSTRAINT `fk_role_default_page_id` FOREIGN KEY (`default_page_id`) REFERENCES `content_pages` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_role_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `roles_permissions` (
  `id` int(11) NOT NULL auto_increment,
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_roles_permission_role_id` (`role_id`),
  KEY `fk_roles_permission_permission_id` (`permission_id`),
  CONSTRAINT `fk_roles_permission_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_roles_permission_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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

CREATE TABLE `site_controllers` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `permission_id` int(11) NOT NULL,
  `builtin` int(10) unsigned default '0',
  PRIMARY KEY  (`id`),
  KEY `fk_site_controller_permission_id` (`permission_id`),
  CONSTRAINT `fk_site_controller_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON UPDATE CASCADE
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
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
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
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `studies_name_index` (`name`),
  KEY `studies_updated_by_index` (`updated_by`),
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
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
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
  `assigned_to` varchar(60) default NULL,
  `status` varchar(255) NOT NULL default 'new',
  `priority` varchar(255) NOT NULL default 'normal',
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `study_stages` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `system_settings` (
  `id` int(11) NOT NULL auto_increment,
  `site_name` varchar(255) NOT NULL,
  `site_subtitle` varchar(255) default NULL,
  `footer_message` varchar(255) default '',
  `public_role_id` int(11) NOT NULL default '0',
  `session_timeout` int(11) NOT NULL default '0',
  `default_markup_style_id` int(11) default '0',
  `site_default_page_id` int(11) NOT NULL default '0',
  `not_found_page_id` int(11) NOT NULL default '0',
  `permission_denied_page_id` int(11) NOT NULL default '0',
  `session_expired_page_id` int(11) NOT NULL default '0',
  `menu_depth` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `fk_system_settings_public_role_id` (`public_role_id`),
  KEY `fk_system_settings_site_default_page_id` (`site_default_page_id`),
  KEY `fk_system_settings_not_found_page_id` (`not_found_page_id`),
  KEY `fk_system_settings_permission_denied_page_id` (`permission_denied_page_id`),
  KEY `fk_system_settings_session_expired_page_id` (`session_expired_page_id`),
  CONSTRAINT `fk_system_settings_not_found_page_id` FOREIGN KEY (`not_found_page_id`) REFERENCES `content_pages` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_system_settings_permission_denied_page_id` FOREIGN KEY (`permission_denied_page_id`) REFERENCES `content_pages` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_system_settings_public_role_id` FOREIGN KEY (`public_role_id`) REFERENCES `roles` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_system_settings_session_expired_page_id` FOREIGN KEY (`session_expired_page_id`) REFERENCES `content_pages` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_system_settings_site_default_page_id` FOREIGN KEY (`site_default_page_id`) REFERENCES `content_pages` (`id`) ON UPDATE CASCADE
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
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `task_id` int(11) default NULL,
  `content_type` varchar(255) default NULL,
  `parent_id` int(11) default NULL,
  `filename` varchar(255) default NULL,
  `thumbnail` varchar(255) default NULL,
  `size` int(11) default NULL,
  `width` int(11) default NULL,
  `height` int(11) default NULL,
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
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `task_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `task_references_task_id_index` (`task_id`),
  KEY `task_references_task_context_id_index` (`task_context_id`),
  KEY `task_references_parameter_id_index` (`parameter_id`),
  KEY `task_references_updated_at_index` (`updated_at`),
  KEY `task_references_updated_by_index` (`updated_by`)
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
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `task_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `task_texts_task_id_index` (`task_id`),
  KEY `task_texts_task_context_id_index` (`task_context_id`),
  KEY `task_texts_parameter_id_index` (`parameter_id`),
  KEY `task_texts_updated_at_index` (`updated_at`),
  KEY `task_texts_updated_by_index` (`updated_by`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `task_values` (
  `id` int(11) NOT NULL auto_increment,
  `task_context_id` int(11) default NULL,
  `parameter_id` int(11) default NULL,
  `data_value` double default NULL,
  `display_unit` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `task_id` int(11) default NULL,
  `storage_unit` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `task_values_task_id_index` (`task_id`),
  KEY `task_values_task_context_id_index` (`task_context_id`),
  KEY `task_values_parameter_id_index` (`parameter_id`),
  KEY `task_values_updated_at_index` (`updated_at`),
  KEY `task_values_updated_by_index` (`updated_by`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tasks` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `experiment_id` int(11) default NULL,
  `protocol_version_id` int(11) default NULL,
  `status_id` int(11) default NULL,
  `is_milestone` tinyint(1) default NULL,
  `assigned_to` varchar(60) default NULL,
  `priority_id` int(11) default NULL,
  `start_date` datetime default NULL,
  `end_date` datetime default NULL,
  `expected_hours` double default NULL,
  `done_hours` double default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `study_protocol_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `tasks_name_index` (`name`),
  KEY `tasks_experiment_id_index` (`experiment_id`),
  KEY `tasks_process_instance_id_index` (`protocol_version_id`),
  KEY `tasks_study_protocol_id_index` (`study_protocol_id`),
  KEY `tasks_start_date_index` (`start_date`),
  KEY `tasks_end_date_index` (`end_date`)
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
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
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

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `password` varchar(40) NOT NULL,
  `role_id` int(11) NOT NULL,
  `password_salt` varchar(255) default NULL,
  `fullname` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_user_role_id` (`role_id`),
  CONSTRAINT `fk_user_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `work_status` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO schema_info (version) VALUES (127)