  create view queue_result_values as
  select ti.id id,
         tc.row_no,
         p.column_no,
         tc.task_id,
         qi.id queue_item_id,
         qi.request_service_id,
         qi.study_queue_id,
         p.parameter_context_id,
         tr.task_context_id,
         tr.parameter_id reference_parameter_id,
         tr.data_element_id,
         tr.data_type,
         tr.data_id,
         tr.data_name subject,
         ti.parameter_id,
         pc.protocol_version_id,
         pc.label,
         tc.label row_label,
         p.name parameter_name,
         ti.data_value,
         ti.created_by_user_id,
         ti.created_at,
         ti.updated_by_user_id,
         ti.updated_at
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