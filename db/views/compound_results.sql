  create view compound_results as
  select ti.id id,
         tc.row_no,
         p.column_no,
         tc.task_id,
         p.parameter_context_id,
         tr.task_context_id,
         tr.data_element_id,
         tr.parameter_id compound_parameter_id,
         tr.data_id      compound_id,
         tr.data_name    compound_name,
         pc.protocol_version_id,
         pc.label,
         tc.label row_label,
         ti.parameter_id,
         p.name parameter_name,
         ti.data_value,
         ti.created_by,
         ti.created_at,
         ti.updated_by,
         ti.updated_at
  from parameter_contexts pc,
       parameters p,
       task_contexts tc,
       task_references tr,
       task_values ti
  where  tc.id = tr.task_context_id 
  and   ti.task_context_id = tc.id 
  and   p.id = ti.parameter_id
  and   pc.id = tc.parameter_context_id 
  and  tr.data_type='Compound'