create view experiment_statistics as 
select  t.experiment_id*1000000+p.assay_parameter_id id,
        t.experiment_id experiment_id,
        p.assay_parameter_id assay_parameter_id,
        p.parameter_role_id parameter_role_id,
        p.parameter_type_id parameter_type_id,
        p.data_type_id data_type_id,
        avg(r.data_value) avg_values,
        sum(null) stddev_values,
 	count(r.data_value) num_values ,
 	count(distinct r.data_value) num_unique ,
	max(r.data_value) max_values ,
	min(r.data_value) min_values 
from task_values r,parameters p, tasks t
where p.id =r.parameter_id
and   t.id =r.task_id
and   p.assay_parameter_id is not null
group by t.experiment_id,
         p.parameter_role_id,
         p.parameter_type_id,
         p.data_type_id,
	 p.assay_parameter_id
;