create view queue_results as
    select ti.id id,
         tc.row_no row_no,
         p.column_no column_no,
         tc.task_id task_id,
         qi.id queue_item_id,
         qi.request_service_id request_service_id,
         qi.assay_queue_id assay_queue_id,
         qi.requested_by_user_id requested_by_user_id,
         qi.assigned_to_user_id assigned_to_user_id,
         p.parameter_context_id parameter_context_id,
         tr.task_context_id task_context_id,
         tr.parameter_id reference_parameter_id,
         tr.data_element_id data_element_id,
         tr.data_type data_type,
         tr.data_id data_id,
         tr.data_name subject,
         ti.parameter_id parameter_id,
         pc.protocol_version_id protocol_version_id,
         pc.label label,
         tc.label row_label,
         p.name parameter_name,
         ti.data_content data_value,
         ti.created_by_user_id created_by_user_id,
         ti.created_at created_at,
         ti.updated_by_user_id updated_by_user_id,
         ti.updated_at updated_at
  from parameter_contexts pc,
       parameters p,
       task_contexts tc,
       task_references tr,
       task_texts ti,
       queue_items qi
  where  tc.id = tr.task_context_id 
  and    ti.task_context_id = tc.id 
  and    p.id = ti.parameter_id
  and    pc.id = tc.parameter_context_id 
  and    qi.task_id   = tr.task_id
  and    qi.data_id   = tr.data_id
  and    qi.data_type = tr.data_type
  and    qi.data_name = tr.data_name
union
  select ti.id id,
         tc.row_no row_no,
         p.column_no column_no,
         tc.task_id task_id,
         qi.id queue_item_id,
         qi.request_service_id request_service_id,
         qi.assay_queue_id assay_queue_id,
         qi.requested_by_user_id requested_by_user_id,
         qi.assigned_to_user_id assigned_to_user_id,
         p.parameter_context_id parameter_context_id,
         tr.task_context_id task_context_id,
         tr.parameter_id reference_parameter_id,
         tr.data_element_id data_element_id,
         tr.data_type data_type,
         tr.data_id data_id,
         tr.data_name subject,
         ti.parameter_id parameter_id,
         pc.protocol_version_id protocol_version_id,
         pc.label label,
         tc.label row_label,
         p.name parameter_name,
         ti.data_value data_value,
         ti.created_by_user_id created_by_user_id,
         ti.created_at created_at,
         ti.updated_by_user_id updated_by_user_id,
         ti.updated_at updated_at
  from parameter_contexts pc,
       parameters p,
       task_contexts tc,
       task_references tr,
       task_values ti,
       queue_items qi
  where  tc.id = tr.task_context_id 
  and    ti.task_context_id = tc.id 
  and    p.id = ti.parameter_id
  and    pc.id = tc.parameter_context_id 
  and    qi.task_id   = tr.task_id
  and    qi.data_id   = tr.data_id
  and    qi.data_type = tr.data_type
  and    qi.data_name = tr.data_name
;
