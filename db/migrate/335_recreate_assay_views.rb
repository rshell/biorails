class RecreateAssayViews < ActiveRecord::Migration
  def self.up

  create_view "assay_statistics", "select `p`.`assay_parameter_id` AS `id`,`p`.`assay_parameter_id` AS `assay_parameter_id`,`e`.`assay_id` AS `assay_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,avg(`r`.`data_value`) AS `avg_values`,std(`r`.`data_value`) AS `stddev_values`,count(`r`.`data_value`) AS `num_values`,count(distinct `r`.`data_value`) AS `num_unique`,max(`r`.`data_value`) AS `max_values`,min(`r`.`data_value`) AS `min_values` from (((`task_values` `r` join `parameters` `p`) join `tasks` `t`) join `experiments` `e`) where ((`p`.`id` = `r`.`parameter_id`) and (`t`.`id` = `r`.`task_id`) and (`e`.`id` = `t`.`experiment_id`) and (`p`.`assay_parameter_id` is not null)) group by `e`.`assay_id`,`p`.`data_type_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`assay_parameter_id` union select `p`.`assay_parameter_id` AS `id`,`p`.`assay_parameter_id` AS `assay_parameter_id`,`e`.`assay_id` AS `assay_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_content`) AS `num_unique`,sum(NULL) AS `max_values`,sum(NULL) AS `min_values` from (((`task_texts` `r` join `parameters` `p`) join `tasks` `t`) join `experiments` `e`) where ((`p`.`id` = `r`.`parameter_id`) and (`t`.`id` = `r`.`task_id`) and (`e`.`id` = `t`.`experiment_id`) and (`p`.`assay_parameter_id` is not null)) group by `e`.`assay_id`,`p`.`data_type_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`assay_parameter_id` union select `p`.`assay_parameter_id` AS `id`,`p`.`assay_parameter_id` AS `assay_parameter_id`,`e`.`assay_id` AS `assay_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_name`) AS `num_unique`,max(`r`.`data_id`) AS `max_values`,min(`r`.`data_id`) AS `min_values` from (((`task_references` `r` join `parameters` `p`) join `tasks` `t`) join `experiments` `e`) where ((`p`.`id` = `r`.`parameter_id`) and (`t`.`id` = `r`.`task_id`) and (`e`.`id` = `t`.`experiment_id`) and (`p`.`assay_parameter_id` is not null)) group by `e`.`assay_id`,`p`.`data_type_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`assay_parameter_id`", :force => true do |v|
    v.column :id
    v.column :assay_parameter_id
    v.column :assay_id
    v.column :parameter_role_id
    v.column :parameter_type_id
    v.column :data_type_id
    v.column :avg_values
    v.column :stddev_values
    v.column :num_values
    v.column :num_unique
    v.column :max_values
    v.column :min_values
  end

  create_view "compound_results", "select `ti`.`id` AS `id`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`p`.`parameter_context_id` AS `parameter_context_id`,`tr`.`task_context_id` AS `task_context_id`,`tr`.`data_element_id` AS `data_element_id`,`tr`.`parameter_id` AS `compound_parameter_id`,`tr`.`data_id` AS `compound_id`,`tr`.`data_name` AS `compound_name`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`ti`.`parameter_id` AS `parameter_id`,`p`.`name` AS `parameter_name`,`ti`.`data_value` AS `data_value`,`ti`.`created_by_user_id` AS `created_by_user_id`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by_user_id` AS `updated_by_user_id`,`ti`.`updated_at` AS `updated_at` from ((((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_references` `tr`) join `task_values` `ti`) where ((`tc`.`id` = `tr`.`task_context_id`) and (`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`) and (`tr`.`data_type` = _latin1'Compound'))", :force => true do |v|
    v.column :id
    v.column :row_no
    v.column :column_no
    v.column :task_id
    v.column :parameter_context_id
    v.column :task_context_id
    v.column :data_element_id
    v.column :compound_parameter_id
    v.column :compound_id
    v.column :compound_name
    v.column :protocol_version_id
    v.column :label
    v.column :row_label
    v.column :parameter_id
    v.column :parameter_name
    v.column :data_value
    v.column :created_by_user_id
    v.column :created_at
    v.column :updated_by_user_id
    v.column :updated_at
  end

  create_view "experiment_statistics", "select ((`t`.`experiment_id` * 1000000) + `p`.`assay_parameter_id`) AS `id`,`t`.`experiment_id` AS `experiment_id`,`p`.`assay_parameter_id` AS `assay_parameter_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,avg(`r`.`data_value`) AS `avg_values`,std(`r`.`data_value`) AS `stddev_values`,count(`r`.`data_value`) AS `num_values`,count(distinct `r`.`data_value`) AS `num_unique`,max(`r`.`data_value`) AS `max_values`,min(`r`.`data_value`) AS `min_values` from ((`task_values` `r` join `parameters` `p`) join `tasks` `t`) where ((`p`.`id` = `r`.`parameter_id`) and (`t`.`id` = `r`.`task_id`) and (`p`.`assay_parameter_id` is not null)) group by `t`.`experiment_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`data_type_id`,`p`.`assay_parameter_id` union select ((`t`.`experiment_id` * 1000000) + `p`.`assay_parameter_id`) AS `id`,`t`.`experiment_id` AS `experiment_id`,`p`.`assay_parameter_id` AS `assay_parameter_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_content`) AS `num_unique`,sum(NULL) AS `max_values`,sum(NULL) AS `min_values` from ((`task_texts` `r` join `parameters` `p`) join `tasks` `t`) where ((`p`.`id` = `r`.`parameter_id`) and (`p`.`assay_parameter_id` is not null) and (`t`.`id` = `r`.`task_id`)) group by `t`.`experiment_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`data_type_id`,`p`.`assay_parameter_id` union select ((`t`.`experiment_id` * 1000000) + `p`.`assay_parameter_id`) AS `id`,`t`.`experiment_id` AS `experiment_id`,`p`.`assay_parameter_id` AS `assay_parameter_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_name`) AS `num_unique`,max(`r`.`data_id`) AS `max_values`,min(`r`.`data_id`) AS `min_values` from ((`task_references` `r` join `parameters` `p`) join `tasks` `t`) where ((`p`.`id` = `r`.`parameter_id`) and (`p`.`assay_parameter_id` is not null) and (`t`.`id` = `r`.`task_id`)) group by `t`.`experiment_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`data_type_id`,`p`.`assay_parameter_id`", :force => true do |v|
    v.column :id
    v.column :experiment_id
    v.column :assay_parameter_id
    v.column :parameter_role_id
    v.column :parameter_type_id
    v.column :data_type_id
    v.column :avg_values
    v.column :stddev_values
    v.column :num_values
    v.column :num_unique
    v.column :max_values
    v.column :min_values
  end

  create_view "process_statistics", "select `p`.`id` AS `id`,`p`.`assay_parameter_id` AS `assay_parameter_id`,`p`.`protocol_version_id` AS `protocol_version_id`,`r`.`parameter_id` AS `parameter_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,avg(`r`.`data_value`) AS `avg_values`,std(`r`.`data_value`) AS `stddev_values`,count(`r`.`data_value`) AS `num_values`,count(distinct `r`.`data_value`) AS `num_unique`,max(`r`.`data_value`) AS `max_values`,min(`r`.`data_value`) AS `min_values` from (`task_values` `r` join `parameters` `p`) where (`p`.`id` = `r`.`parameter_id`) group by `p`.`assay_parameter_id`,`p`.`protocol_version_id`,`r`.`parameter_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`id` union select `p`.`id` AS `id`,`p`.`assay_parameter_id` AS `assay_parameter_id`,`p`.`protocol_version_id` AS `protocol_version_id`,`r`.`parameter_id` AS `parameter_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_content`) AS `num_unique`,sum(NULL) AS `max_values`,sum(NULL) AS `min_values` from (`task_texts` `r` join `parameters` `p`) where (`p`.`id` = `r`.`parameter_id`) group by `p`.`assay_parameter_id`,`p`.`protocol_version_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`r`.`parameter_id`,`p`.`id` union select `p`.`id` AS `id`,`p`.`assay_parameter_id` AS `assay_parameter_id`,`p`.`protocol_version_id` AS `protocol_version_id`,`r`.`parameter_id` AS `parameter_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_name`) AS `num_unique`,max(`r`.`data_id`) AS `max_values`,min(`r`.`data_id`) AS `min_values` from (`task_references` `r` join `parameters` `p`) where (`p`.`id` = `r`.`parameter_id`) group by `p`.`assay_parameter_id`,`p`.`protocol_version_id`,`r`.`parameter_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`id`", :force => true do |v|
    v.column :id
    v.column :assay_parameter_id
    v.column :protocol_version_id
    v.column :parameter_id
    v.column :parameter_role_id
    v.column :parameter_type_id
    v.column :avg_values
    v.column :stddev_values
    v.column :num_values
    v.column :num_unique
    v.column :max_values
    v.column :min_values
  end

  create_view "queue_result_texts", "select `ti`.`id` AS `id`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`qi`.`id` AS `queue_item_id`,`qi`.`request_service_id` AS `request_service_id`,`qi`.`assay_queue_id` AS `assay_queue_id`,`p`.`parameter_context_id` AS `parameter_context_id`,`tr`.`task_context_id` AS `task_context_id`,`tr`.`parameter_id` AS `reference_parameter_id`,`tr`.`data_element_id` AS `data_element_id`,`tr`.`data_type` AS `data_type`,`tr`.`data_id` AS `data_id`,`tr`.`data_name` AS `subject`,`ti`.`parameter_id` AS `parameter_id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`p`.`name` AS `parameter_name`,`ti`.`data_content` AS `data_value`,`ti`.`created_by_user_id` AS `created_by_user_id`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by_user_id` AS `updated_by_user_id`,`ti`.`updated_at` AS `updated_at` from (((((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_references` `tr`) join `task_texts` `ti`) join `queue_items` `qi`) where ((`tc`.`id` = `tr`.`task_context_id`) and (`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`) and (`qi`.`task_id` = `tr`.`task_id`) and (`qi`.`data_id` = `tr`.`data_id`) and (`qi`.`data_type` = `tr`.`data_type`) and (`qi`.`data_name` = `tr`.`data_name`))", :force => true do |v|
    v.column :id
    v.column :row_no
    v.column :column_no
    v.column :task_id
    v.column :queue_item_id
    v.column :request_service_id
    v.column :assay_queue_id
    v.column :parameter_context_id
    v.column :task_context_id
    v.column :reference_parameter_id
    v.column :data_element_id
    v.column :data_type
    v.column :data_id
    v.column :subject
    v.column :parameter_id
    v.column :protocol_version_id
    v.column :label
    v.column :row_label
    v.column :parameter_name
    v.column :data_value
    v.column :created_by_user_id
    v.column :created_at
    v.column :updated_by_user_id
    v.column :updated_at
  end

  create_view "queue_result_values", "select `ti`.`id` AS `id`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`qi`.`id` AS `queue_item_id`,`qi`.`request_service_id` AS `request_service_id`,`qi`.`assay_queue_id` AS `assay_queue_id`,`p`.`parameter_context_id` AS `parameter_context_id`,`tr`.`task_context_id` AS `task_context_id`,`tr`.`parameter_id` AS `reference_parameter_id`,`tr`.`data_element_id` AS `data_element_id`,`tr`.`data_type` AS `data_type`,`tr`.`data_id` AS `data_id`,`tr`.`data_name` AS `subject`,`ti`.`parameter_id` AS `parameter_id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`p`.`name` AS `parameter_name`,`ti`.`data_value` AS `data_value`,`ti`.`created_by_user_id` AS `created_by_user_id`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by_user_id` AS `updated_by_user_id`,`ti`.`updated_at` AS `updated_at` from (((((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_references` `tr`) join `task_values` `ti`) join `queue_items` `qi`) where ((`tc`.`id` = `tr`.`task_context_id`) and (`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`) and (`qi`.`task_id` = `tr`.`task_id`) and (`qi`.`data_id` = `tr`.`data_id`) and (`qi`.`data_type` = `tr`.`data_type`) and (`qi`.`data_name` = `tr`.`data_name`))", :force => true do |v|
    v.column :id
    v.column :row_no
    v.column :column_no
    v.column :task_id
    v.column :queue_item_id
    v.column :request_service_id
    v.column :assay_queue_id
    v.column :parameter_context_id
    v.column :task_context_id
    v.column :reference_parameter_id
    v.column :data_element_id
    v.column :data_type
    v.column :data_id
    v.column :subject
    v.column :parameter_id
    v.column :protocol_version_id
    v.column :label
    v.column :row_label
    v.column :parameter_name
    v.column :data_value
    v.column :created_by_user_id
    v.column :created_at
    v.column :updated_by_user_id
    v.column :updated_at
  end

  create_view "queue_results", "select `ti`.`id` AS `id`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`qi`.`id` AS `queue_item_id`,`qi`.`request_service_id` AS `request_service_id`,`qi`.`assay_queue_id` AS `assay_queue_id`,`qi`.`requested_by_user_id` AS `requested_by_user_id`,`qi`.`assigned_to_user_id` AS `assigned_to_user_id`,`p`.`parameter_context_id` AS `parameter_context_id`,`tr`.`task_context_id` AS `task_context_id`,`tr`.`parameter_id` AS `reference_parameter_id`,`tr`.`data_element_id` AS `data_element_id`,`tr`.`data_type` AS `data_type`,`tr`.`data_id` AS `data_id`,`tr`.`data_name` AS `subject`,`ti`.`parameter_id` AS `parameter_id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`p`.`name` AS `parameter_name`,`ti`.`data_content` AS `data_value`,`ti`.`created_by_user_id` AS `created_by_user_id`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by_user_id` AS `updated_by_user_id`,`ti`.`updated_at` AS `updated_at` from (((((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_references` `tr`) join `task_texts` `ti`) join `queue_items` `qi`) where ((`tc`.`id` = `tr`.`task_context_id`) and (`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`) and (`qi`.`task_id` = `tr`.`task_id`) and (`qi`.`data_id` = `tr`.`data_id`) and (`qi`.`data_type` = `tr`.`data_type`) and (`qi`.`data_name` = `tr`.`data_name`)) union select `ti`.`id` AS `id`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`qi`.`id` AS `queue_item_id`,`qi`.`request_service_id` AS `request_service_id`,`qi`.`assay_queue_id` AS `assay_queue_id`,`qi`.`requested_by_user_id` AS `requested_by_user_id`,`qi`.`assigned_to_user_id` AS `assigned_to_user_id`,`p`.`parameter_context_id` AS `parameter_context_id`,`tr`.`task_context_id` AS `task_context_id`,`tr`.`parameter_id` AS `reference_parameter_id`,`tr`.`data_element_id` AS `data_element_id`,`tr`.`data_type` AS `data_type`,`tr`.`data_id` AS `data_id`,`tr`.`data_name` AS `subject`,`ti`.`parameter_id` AS `parameter_id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`p`.`name` AS `parameter_name`,`ti`.`data_value` AS `data_value`,`ti`.`created_by_user_id` AS `created_by_user_id`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by_user_id` AS `updated_by_user_id`,`ti`.`updated_at` AS `updated_at` from (((((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_references` `tr`) join `task_values` `ti`) join `queue_items` `qi`) where ((`tc`.`id` = `tr`.`task_context_id`) and (`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`) and (`qi`.`task_id` = `tr`.`task_id`) and (`qi`.`data_id` = `tr`.`data_id`) and (`qi`.`data_type` = `tr`.`data_type`) and (`qi`.`data_name` = `tr`.`data_name`))", :force => true do |v|
    v.column :id
    v.column :row_no
    v.column :column_no
    v.column :task_id
    v.column :queue_item_id
    v.column :request_service_id
    v.column :assay_queue_id
    v.column :requested_by_user_id
    v.column :assigned_to_user_id
    v.column :parameter_context_id
    v.column :task_context_id
    v.column :reference_parameter_id
    v.column :data_element_id
    v.column :data_type
    v.column :data_id
    v.column :subject
    v.column :parameter_id
    v.column :protocol_version_id
    v.column :label
    v.column :row_label
    v.column :parameter_name
    v.column :data_value
    v.column :created_by_user_id
    v.column :created_at
    v.column :updated_by_user_id
    v.column :updated_at
  end

  create_view "task_result_texts", "select `ti`.`id` AS `id`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`p`.`parameter_context_id` AS `parameter_context_id`,`tr`.`task_context_id` AS `task_context_id`,`tr`.`parameter_id` AS `reference_parameter_id`,`tr`.`data_element_id` AS `data_element_id`,`tr`.`data_type` AS `data_type`,`tr`.`data_id` AS `data_id`,`tr`.`data_name` AS `subject`,`ti`.`parameter_id` AS `parameter_id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`p`.`name` AS `parameter_name`,`ti`.`data_content` AS `data_value`,`ti`.`created_by_user_id` AS `created_by_user_id`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by_user_id` AS `updated_by_user_id`,`ti`.`updated_at` AS `updated_at` from ((((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_references` `tr`) join `task_texts` `ti`) where ((`tc`.`id` = `tr`.`task_context_id`) and (`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and `pc`.`id`)", :force => true do |v|
    v.column :id
    v.column :row_no
    v.column :column_no
    v.column :task_id
    v.column :parameter_context_id
    v.column :task_context_id
    v.column :reference_parameter_id
    v.column :data_element_id
    v.column :data_type
    v.column :data_id
    v.column :subject
    v.column :parameter_id
    v.column :protocol_version_id
    v.column :label
    v.column :row_label
    v.column :parameter_name
    v.column :data_value
    v.column :created_by_user_id
    v.column :created_at
    v.column :updated_by_user_id
    v.column :updated_at
  end

  create_view "task_result_values", "select `ti`.`id` AS `id`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`p`.`parameter_context_id` AS `parameter_context_id`,`tr`.`task_context_id` AS `task_context_id`,`tr`.`parameter_id` AS `reference_parameter_id`,`tr`.`data_element_id` AS `data_element_id`,`tr`.`data_type` AS `data_type`,`tr`.`data_id` AS `data_id`,`tr`.`data_name` AS `subject`,`ti`.`parameter_id` AS `parameter_id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`p`.`name` AS `parameter_name`,`ti`.`data_value` AS `data_value`,`ti`.`created_by_user_id` AS `created_by_USER_ID`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by_user_id` AS `updated_by_USER_ID`,`ti`.`updated_at` AS `updated_at` from ((((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_references` `tr`) join `task_values` `ti`) where ((`tc`.`id` = `tr`.`task_context_id`) and (`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`))", :force => true do |v|
    v.column :id
    v.column :row_no
    v.column :column_no
    v.column :task_id
    v.column :parameter_context_id
    v.column :task_context_id
    v.column :reference_parameter_id
    v.column :data_element_id
    v.column :data_type
    v.column :data_id
    v.column :subject
    v.column :parameter_id
    v.column :protocol_version_id
    v.column :label
    v.column :row_label
    v.column :parameter_name
    v.column :data_value
    v.column :created_by_USER_ID
    v.column :created_at
    v.column :updated_by_USER_ID
    v.column :updated_at
  end

  create_view "task_results", "select `ti`.`id` AS `id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`id` AS `parameter_context_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`ti`.`parameter_id` AS `parameter_id`,`p`.`name` AS `parameter_name`,`ti`.`data_value` AS `data_value`,`ti`.`created_by_user_id` AS `created_by_user_id`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by_user_id` AS `updated_by_user_id`,`ti`.`updated_at` AS `updated_at` from (((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_values` `ti`) where ((`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`)) union select `ti`.`id` AS `id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`id` AS `parameter_context_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`ti`.`parameter_id` AS `parameter_id`,`p`.`name` AS `parameter_name`,`ti`.`data_content` AS `data_value`,`ti`.`created_by_user_id` AS `created_by_user_id`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by_user_id` AS `updated_by_user_id`,`ti`.`updated_at` AS `updated_at` from (((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_texts` `ti`) where ((`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`)) union select `ti`.`id` AS `id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`id` AS `parameter_context_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`ti`.`parameter_id` AS `parameter_id`,`p`.`name` AS `parameter_name`,`ti`.`data_name` AS `data_value`,`ti`.`created_by_user_id` AS `created_by_user_id`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by_user_id` AS `updated_by_user_id`,`ti`.`updated_at` AS `updated_at` from (((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_references` `ti`) where ((`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`))", :force => true do |v|
    v.column :id
    v.column :protocol_version_id
    v.column :parameter_context_id
    v.column :label
    v.column :row_label
    v.column :row_no
    v.column :column_no
    v.column :task_id
    v.column :parameter_id
    v.column :parameter_name
    v.column :data_value
    v.column :created_by_user_id
    v.column :created_at
    v.column :updated_by_user_id
    v.column :updated_at
  end

  create_view "task_statistics", "select ((`r`.`task_id` * 100000) + `r`.`parameter_id`) AS `id`,`r`.`task_id` AS `task_id`,`r`.`parameter_id` AS `parameter_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,avg(`r`.`data_value`) AS `avg_values`,std(`r`.`data_value`) AS `stddev_values`,count(`r`.`data_value`) AS `num_values`,count(distinct `r`.`data_value`) AS `num_unique`,max(`r`.`data_value`) AS `max_values`,min(`r`.`data_value`) AS `min_values` from (`task_values` `r` join `parameters` `p`) where (`p`.`id` = `r`.`parameter_id`) group by `r`.`task_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`data_type_id` union select ((`r`.`task_id` * 100000) + `r`.`parameter_id`) AS `id`,`r`.`task_id` AS `task_id`,`r`.`parameter_id` AS `parameter_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_content`) AS `num_unique`,sum(NULL) AS `max_values`,sum(NULL) AS `min_values` from (`task_texts` `r` join `parameters` `p`) where (`p`.`id` = `r`.`parameter_id`) group by `r`.`task_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`data_type_id` union select ((`r`.`task_id` * 100000) + `r`.`parameter_id`) AS `id`,`r`.`task_id` AS `task_id`,`r`.`parameter_id` AS `parameter_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_name`) AS `num_unique`,max(`r`.`data_id`) AS `max_values`,min(`r`.`data_id`) AS `min_values` from (`task_references` `r` join `parameters` `p`) where (`p`.`id` = `r`.`parameter_id`) group by `r`.`task_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`data_type_id`", :force => true do |v|
    v.column :id
    v.column :task_id
    v.column :parameter_id
    v.column :parameter_role_id
    v.column :parameter_type_id
    v.column :data_type_id
    v.column :avg_values
    v.column :stddev_values
    v.column :num_values
    v.column :num_unique
    v.column :max_values
    v.column :min_values
  end

  end

  def self.down
  end
end
