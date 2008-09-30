create view queue_results as
    select ti.id                AS id,
         tc.row_no              AS row_no,
         p.column_no            AS column_no,
         tc.task_id             AS task_id,
         qi.id                  AS queue_item_id,
         qi.request_service_id AS request_service_id,
         qi.assay_queue_id     AS  assay_queue_id,
         qi.requested_by_user_id AS requested_by_user_id,
         qi.assigned_to_user_id AS  assigned_to_user_id,
         p.parameter_context_id AS parameter_context_id,
         tr.task_context_id     AS task_context_id,,
         tr.parameter_id        AS reference_parameter_id,
         tr.data_element_id     AS data_element_id,
         tr.data_type           AS data_type,
         tr.data_id             AS data_id,
         tr.data_name           AS subject,
         ti.parameter_id        AS parameter_id,
         pc.protocol_version_id AS protocol_version_id,
         pc.label               AS label,
         tc.label               AS row_label,
         p.name                 AS parameter_name,
         ti.data_content        AS data_value,
         ti.created_by_user_id  AS created_by_user_id,
         ti.created_at          AS created_at,
         ti.updated_by_user_id  AS updated_by_user_id,
         ti.updated_at          AS updated_at
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
  select ti.id                  AS id,
         tc.row_no              AS row_no,
         p.column_no            AS column_no,
         tc.task_id             AS task_id,
         qi.id                  AS queue_item_id,
         qi.request_service_id  AS request_service_id,
         qi.assay_queue_id      AS assay_queue_id,
         qi.requested_by_user_id AS requested_by_user_id,
         qi.assigned_to_user_id AS assigned_to_user_id,
         p.parameter_context_id AS parameter_context_id,
         tr.task_context_id     AS task_context_id,,
         tr.parameter_id        AS reference_parameter_id,
         tr.data_element_id     AS data_element_id,
         tr.data_type           AS data_type,
         tr.data_id             AS data_id,
         tr.data_name           AS subject,
         ti.parameter_id        AS parameter_id,
         pc.protocol_version_id AS protocol_version_id,
         pc.label               AS label,
         tc.label               AS row_label,
         p.name                 AS parameter_name,
         ti.data_value          AS data_value,
         ti.created_by_user_id  AS created_by_user_id,
         ti.created_at          AS created_at,
         ti.updated_by_user_id  AS updated_by_user_id,
         ti.updated_at          AS updated_at
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