class NumericOnlyStatsViews < ActiveRecord::Migration

  def self.execute_ignore_error(sql)
    execute sql
  rescue  Exception => ex
     puts 'Ignoring SQL error'+ex.message    
  end
  
  def self.up

#-----------study_statistics---------------------------------------
  execute_ignore_error 'drop view study_statistics'
  execute_ignore_error 'drop view study_statistics'
  
  execute_ignore_error <<SQL
create view study_statistics as 
select p.study_parameter_id id,
       p.study_parameter_id,
       e.study_id,
       p.parameter_role_id,
       p.parameter_type_id,
       p.data_type_id,
       avg(r.data_value) avg_values,
       stddev(r.data_value) stddev_values,
       count(r.data_value) num_values,
       count(distinct r.data_value) num_unique,
       max(r.data_value) max_values,
       min(r.data_value) min_values
  from task_values r, parameters p, tasks t, experiments e
 where p.id = r.parameter_id
   and t.id = r.task_id
   and e.id = t.experiment_id
   and p.study_parameter_id is not null
 group by e.study_id,
          p.data_type_id,
          p.parameter_role_id,
          p.parameter_type_id,
          p.study_parameter_id
SQL

#-----------experiment_statistics---------------------------------------

  execute_ignore_error 'drop table experiment_statistics'
  execute_ignore_error 'drop view experiment_statistics'

  execute_ignore_error <<SQL
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
SQL

#-----------process_statistics---------------------------------------

  execute_ignore_error 'drop table process_statistics'
  execute_ignore_error 'drop view process_statistics'

 execute_ignore_error <<SQL
create view process_statistics as 
select p.id,
       p.study_parameter_id,
       p.protocol_version_id,
       r.parameter_id,
       p.parameter_role_id,
       p.parameter_type_id,
       avg(r.data_value) avg_values,
       stddev(r.data_value) stddev_values,
       count(r.data_value) num_values,
       count(distinct r.data_value) num_unique,
       max(r.data_value) max_values,
       min(r.data_value) min_values
  from task_values r, parameters p
 where p.id = r.parameter_id
 group by p.study_parameter_id,
          p.protocol_version_id,
          r.parameter_id,
          p.parameter_role_id,
          p.parameter_type_id,
          p.id
SQL

#-----------task_statistics---------------------------------------
  execute_ignore_error 'drop table task_statistics'
  execute_ignore_error 'drop view task_statistics'
   
  execute_ignore_error <<SQL
create or replace view task_statistics as
    select (r.task_id*100000+r.parameter_id) id,
    r.task_id,
    r.parameter_id,
    p.parameter_role_id,
    p.parameter_type_id,
    p.data_type_id,
    avg(r.data_value) avg_values,
    stddev(r.data_value) stddev_values,
    count(r.data_value) num_values ,
    count(distinct r.data_value) num_unique ,
    max(r.data_value) max_values ,
    min(r.data_value) min_values
from task_values r,
     parameters p
where p.id =r.parameter_id
group by r.task_id,
         p.parameter_role_id,
         p.parameter_type_id,
         p.data_type_id,
         r.parameter_id
SQL
  end

  def self.down
  end
end
