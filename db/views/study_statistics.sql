create view study_statistics as 
select
    p.study_parameter_id id,
    p.study_parameter_id,
    e.study_id,
    p.parameter_role_id,
    p.parameter_type_id,
    p.data_type_id,
        avg(r.data_value) avg_values,
	stddev(r.data_value) stddev_values,
 	count(r.data_value) num_values ,
 	count(distinct r.data_value) num_unique ,
	max(r.data_value) max_values ,
	min(r.data_value) min_values 
from task_values r, parameters p, tasks t, experiments e
where p.id =r.parameter_id
and   t.id =r.task_id
and   e.id =t.experiment_id
and   p.study_parameter_id is not null
group by e.study_id,
         p.parameter_role_id,
         p.parameter_type_id,
	     p.study_parameter_id
union
select 
    p.study_parameter_id id,
    p.study_parameter_id,
    e.study_id,
    p.parameter_role_id,
    p.parameter_type_id,
    p.data_type_id,
        sum(null) avg_values,
	sum(null) stddev_values,
 	count(r.id) num_values ,
 	count(distinct r.data_content) num_unique ,
	sum(null) max_values ,
	sum(null) min_values 
from task_texts r,parameters p, tasks t, experiments e
where p.id =r.parameter_id
and   t.id =r.task_id
and   e.id =t.experiment_id
and   p.study_parameter_id is not null
group by e.study_id,
         p.parameter_role_id,
         p.parameter_type_id,
	     p.study_parameter_id
union
select 
    p.study_parameter_id id,
    p.study_parameter_id,
    e.study_id,
    p.parameter_role_id,
    p.parameter_type_id,
    p.data_type_id,
        sum(null) avg_values,
	sum(null) stddev_values,
 	count(r.id) num_values ,
 	count(distinct r.data_name) num_unique ,
	max(r.data_id) max_values ,
	min(r.data_id) min_values 
from task_references r, parameters p, tasks t, experiments e
where p.id =r.parameter_id
and   t.id =r.task_id
and   e.id =t.experiment_id
and   p.study_parameter_id is not null
group by e.study_id,
         p.parameter_role_id,
         p.parameter_type_id,
       p.study_parameter_id