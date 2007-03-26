class RebuildStatsViews < ActiveRecord::Migration
  def self.up

###
# Task statistics 
#   
    execute "drop view task_statistics"
    
    task_stats_sql =<<SQL
create view task_statistics as 
select (r.task_id*100000+r.parameter_id) id,r.task_id,r.parameter_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id,
    avg(r.data_value) avg_values,
	stddev(r.data_value) stddev_values,
 	count(r.data_value) num_values ,
 	count(distinct r.data_value) num_unique ,
	max(r.data_value) max_values ,
	min(r.data_value) min_values 
from task_values r,parameters p
where p.id =r.parameter_id
group by r.task_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id
union
select (r.task_id*100000+r.parameter_id) id,r.task_id,r.parameter_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id,
    sum(null) avg_values,
	sum(null) stddev_values,
 	count(r.id) num_values ,
 	count(distinct r.data_content) num_unique ,
	min(data_content) max_values ,
	max(data_content) min_values 
from task_texts r,parameters p
where p.id =r.parameter_id
group by r.task_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id
union
select (r.task_id*100000+r.parameter_id) id,r.task_id,r.parameter_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id,
    sum(null) avg_values,
	sum(null) stddev_values,
 	count(r.id) num_values ,
 	count(distinct r.data_name) num_unique ,
	max(r.data_name) max_values ,
	min(r.data_name) min_values 
from task_references r,parameters p
where p.id =r.parameter_id
group by r.task_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id    
SQL
  execute task_stats_sql
  
  execute "drop view process_statistics"

  parameter_stats_sql = <<SQL
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
SQL
  execute parameter_stats_sql



  execute "drop view study_statistics"

  study_parameter_stats_sql = <<SQL
create view study_statistics as 
select
    p.study_parameter_id id,
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
SQL
  execute study_parameter_stats_sql
  
  execute "drop view experiment_statistics"

  expt_stats_sql = <<SQL
create view experiment_statistics as 
select  t.experiment_id*1000000+p.study_parameter_id id,
        t.experiment_id,
        p.study_parameter_id,
        p.parameter_role_id,
        p.parameter_type_id,
        p.data_type_id,
        avg(r.data_value) avg_values,
	stddev(r.data_value) stddev_values,
 	count(r.data_value) num_values ,
 	count(distinct r.data_value) num_unique ,
	max(r.data_value) max_values ,
	min(r.data_value) min_values 
from task_values r,parameters p, tasks t
where p.id =r.parameter_id
and   t.id =r.task_id
and   p.study_parameter_id is not null
group by t.experiment_id,
         p.parameter_role_id,
         p.parameter_type_id,
         p.data_type_id,
	 p.study_parameter_id
union
select t.experiment_id*1000000+p.study_parameter_id id,
       t.experiment_id,
       p.study_parameter_id,
       p.parameter_role_id,
       p.parameter_type_id,
       p.data_type_id,
        sum(null) avg_values,
	sum(null) stddev_values,
 	count(r.id) num_values ,
 	count(distinct r.data_content) num_unique ,
	sum(null) max_values ,
	sum(null) min_values 
from task_texts r,parameters p, tasks t
where p.id =r.parameter_id
and   p.study_parameter_id is not null
and   t.id =r.task_id
group by t.experiment_id,
         p.parameter_role_id,
         p.parameter_type_id,
         p.data_type_id,
	 p.study_parameter_id
union
select t.experiment_id*1000000+p.study_parameter_id id,
       t.experiment_id,
       p.study_parameter_id,
       p.parameter_role_id,
       p.parameter_type_id,
       p.data_type_id,
       sum(null) avg_values,
	sum(null) stddev_values,
 	count(r.id) num_values ,
 	count(distinct r.data_name) num_unique ,
	max(r.data_id) max_values ,
	min(r.data_id) min_values 
from task_references r,parameters p, tasks t
where p.id =r.parameter_id
and   p.study_parameter_id is not null
and   t.id =r.task_id
group by t.experiment_id,
         p.parameter_role_id,
         p.parameter_type_id,
         p.data_type_id,
	 p.study_parameter_id
SQL
  execute expt_stats_sql   
 	     
  end

  def self.down
  ##
  # Sorry not included.
  
  end
end
