  create view task_results as
  select ti.id id,
         pc.protocol_version_id protocol_version_id,
         pc.id parameter_context_id,
         pc.label label,
         tc.label row_label,
         tc.row_no row_no,
         p.column_no column_no,
         tc.task_id task_id,
         ti.parameter_id parameter_id,
         p.name parameter_name,
         ti.data_value data_value,
         ti.storage_unit data_unit,
         ti.created_by_user_id created_by_user_id,
         ti.created_at created_at,
         ti.updated_by_user_id updated_by_user_id,
         ti.updated_at updated_at
  from parameter_contexts pc,
       parameters p,
       task_contexts tc,
       task_values ti
  where ti.task_context_id = tc.id 
  and   p.id  = ti.parameter_id
  and   pc.id = tc.parameter_context_id 
  union
  select ti.id id,
         pc.protocol_version_id protocol_version_id,
         pc.id parameter_context_id,
         pc.label label,
         tc.label row_label,
         tc.row_no row_no,
         p.column_no column_no,
         tc.task_id task_id,
         ti.parameter_id parameter_id,
         p.name parameter_name,
         ti.data_content data_value,
         'text' data_unit,
         ti.created_by_user_id created_by_user_id,
         ti.created_at created_at,
         ti.updated_by_user_id updated_by_user_id,
         ti.updated_at updated_at
  from parameter_contexts pc,
       parameters p,
       task_contexts tc,
       task_texts ti
  where ti.task_context_id = tc.id 
  and   p.id  = ti.parameter_id
  and   pc.id = tc.parameter_context_id 
  union
  select ti.id id,
         pc.protocol_version_id protocol_version_id,
         pc.id parameter_context_id,
         pc.label label,
         tc.label row_label,
         tc.row_no row_no,
         p.column_no column_no,
         tc.task_id task_id,
         ti.parameter_id parameter_id,
         p.name parameter_name,
         ti.data_name data_value,
         'text' data_unit,
         ti.created_by_user_id created_by_user_id,
         ti.created_at created_at,
         ti.updated_by_user_id updated_by_user_id,
         ti.updated_at updated_at
  from parameter_contexts pc,
       parameters p,
       task_contexts tc,
       task_references ti
  where ti.task_context_id = tc.id 
  and   p.id  = ti.parameter_id
  and   pc.id = tc.parameter_context_id  ; 
