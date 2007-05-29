  create view task_results as
  select ti.id id,
         pc.protocol_version_id,
         pc.id parameter_context_id,
         pc.label,
         tc.label row_label,
         tc.row_no,
         p.column_no,
         tc.task_id,
         ti.parameter_id,
         p.name parameter_name,
         ti.data_value data_value,
         ti.created_by,
         ti.created_at,
         ti.updated_by,
         ti.updated_at
  from parameter_contexts pc,
       parameters p,
       task_contexts tc,
       task_values ti
  where ti.task_context_id = tc.id 
  and   p.id  = ti.parameter_id
  and   pc.id = tc.parameter_context_id 
  union
  select ti.id id,
         pc.protocol_version_id,
         pc.id parameter_context_id,
         pc.label,
         tc.label row_label,
         tc.row_no,
         p.column_no,
         tc.task_id,
         ti.parameter_id,
         p.name parameter_name,
         ti.data_content data_value,
         ti.created_by,
         ti.created_at,
         ti.updated_by,
         ti.updated_at
  from parameter_contexts pc,
       parameters p,
       task_contexts tc,
       task_texts ti
  where ti.task_context_id = tc.id 
  and   p.id  = ti.parameter_id
  and   pc.id = tc.parameter_context_id 
  union
  select ti.id id,
         pc.protocol_version_id,
         pc.id parameter_context_id,
         pc.label,
         tc.label row_label,
         tc.row_no,
         p.column_no,
         tc.task_id,
         ti.parameter_id,
         p.name parameter_name,
         ti.data_content data_value,
         ti.created_by,
         ti.created_at,
         ti.updated_by,
         ti.updated_at
  from parameter_contexts pc,
       parameters p,
       task_contexts tc,
       task_texts ti
  where ti.task_context_id = tc.id 
  and   p.id  = ti.parameter_id
  and   pc.id = tc.parameter_context_id 
  union
  select ti.id id,
         pc.protocol_version_id,
         pc.id parameter_context_id,
         pc.label,
         tc.label row_label,
         tc.row_no,
         p.column_no,
         tc.task_id,
         ti.parameter_id,
         p.name parameter_name,
         ti.data_name data_value,
         ti.created_by,
         ti.created_at,
         ti.updated_by,
         ti.updated_at
  from parameter_contexts pc,
       parameters p,
       task_contexts tc,
       task_references ti
  where ti.task_context_id = tc.id 
  and   p.id  = ti.parameter_id
  and   pc.id = tc.parameter_context_id    
