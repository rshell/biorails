create view process_statistics as 
select  p.id,
        p.study_parameter_id,
        p.protocol_version_id,
        r.parameter_id,
        p.parameter_role_id,
        p.parameter_type_id,
        avg(r.data_value) avg_values,
	stddev(r.data_value) stddev_values,
 	count(r.data_value) num_values ,
 	count(distinct r.data_value) num_unique ,
	max(r.data_value) max_values ,
	min(r.data_value) min_values 
from task_values r,parameters p
where p.id =r.parameter_id
group by p.study_parameter_id,
         p.protocol_version_id,
         r.parameter_id,
         p.id
union
select p.id,
        p.study_parameter_id,
        p.protocol_version_id,
        r.parameter_id,
        p.parameter_role_id,
        p.parameter_type_id,
        sum(null) avg_values,
	sum(null) stddev_values,
 	count(r.id) num_values ,
 	count(distinct r.data_content) num_unique ,
	sum(null) max_values ,
	sum(null) min_values 
from task_texts r,parameters p
where p.id =r.parameter_id
group by p.study_parameter_id,
         p.protocol_version_id,
         r.parameter_id,
         p.id
union
select p.id,
        p.study_parameter_id,
        p.protocol_version_id,
        r.parameter_id,
        p.parameter_role_id,
        p.parameter_type_id,
        sum(null) avg_values,
	sum(null) stddev_values,
 	count(r.id) num_values ,
 	count(distinct r.data_name) num_unique ,
	max(r.data_id) max_values ,
	min(r.data_id) min_values 
from task_references r,parameters p
where p.id =r.parameter_id
group by p.study_parameter_id,
         p.protocol_version_id,
         r.parameter_id,
         p.id
