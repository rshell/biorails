##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class CreateExperimentStatistics < ActiveRecord::Migration
  def self.up
    sql = <<SQL
create view experiment_statistics as 
select  t.experiment_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id,
        avg(r.data_value) avg_values,
	stddev(r.data_value) stddev_values,
 	count(r.data_value) num_values ,
 	count(distinct r.data_value) num_unique ,
	max(r.data_value) max_values ,
	min(r.data_value) min_values 
from task_values r,parameters p, tasks t
where p.id =r.parameter_id
and   t.id =r.task_id
group by t.experiment_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id
union
select t.experiment_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id,
        sum(null) avg_values,
	sum(null) stddev_values,
 	count(r.id) num_values ,
 	count(distinct r.data_content) num_unique ,
	min(data_content) max_values ,
	max(data_content) min_values 
from task_texts r,parameters p, tasks t
where p.id =r.parameter_id
and   t.id =r.task_id
group by t.experiment_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id
union
select t.experiment_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id,
        sum(null) avg_values,
	sum(null) stddev_values,
 	count(r.id) num_values ,
 	count(distinct r.data_name) num_unique ,
	max(r.data_name) max_values ,
	min(r.data_name) min_values 
from task_references r,parameters p, tasks t
where p.id =r.parameter_id
and   t.id =r.task_id
group by t.experiment_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id
SQL
    execute sql
 end

  def self.down
    execute 'drop view experiment_statistics'
  end
end
