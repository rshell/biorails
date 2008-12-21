create view process_statistics as 
select p.id id,
       p.assay_parameter_id assay_parameter_id,
       p.protocol_version_id protocol_version_id,
       r.parameter_id parameter_id,
       p.parameter_role_id parameter_role_id,
       p.parameter_type_id parameter_type_id,
       avg(r.data_value) avg_values,
       sum(null) stddev_values,
       count(r.data_value) num_values,
       count(distinct r.data_value) num_unique,
       max(r.data_value) max_values,
       min(r.data_value) min_values
  from task_values r, parameters p
 where p.id = r.parameter_id
 group by p.assay_parameter_id,
          p.protocol_version_id,
          r.parameter_id,
          p.parameter_role_id,
          p.parameter_type_id,
          p.id
;