##
# Copyright Â© 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#
class InitialViews < ActiveRecord::Migration
  def self.up

#-----------study_statistics---------------------------------------
  
  execute <<SQL
create view study_statistics as 
select e.study_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id,
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
group by e.study_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id
union
select e.study_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id,
    sum(null) avg_values,
  sum(null) stddev_values,
  count(r.id) num_values ,
  count(distinct r.data_content) num_unique ,
  min(data_content) max_values ,
  max(data_content) min_values 
from task_texts r,parameters p, tasks t, experiments e
where p.id =r.parameter_id
and   t.id =r.task_id
and   e.id =t.experiment_id
group by e.study_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id
union
select e.study_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id,
    sum(null) avg_values,
  sum(null) stddev_values,
  count(r.id) num_values ,
  count(distinct r.data_name) num_unique ,
  max(r.data_name) max_values ,
  min(r.data_name) min_values 
from task_references r, parameters p, tasks t, experiments e
where p.id =r.parameter_id
and   t.id =r.task_id
and   e.id =t.experiment_id
group by e.study_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id
SQL

#-----------experiment_statistics---------------------------------------

    execute <<SQL
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

#-----------process_statistics---------------------------------------

    execute <<SQL
create view process_statistics as 
select p.id,p.process_instance_id,r.parameter_id, 
    p.parameter_type_id, p.parameter_role_id,
    avg(r.data_value) avg_values,
  stddev(r.data_value) stddev_values,
  count(r.data_value) num_values ,
  count(distinct r.data_value) num_unique ,
  max(r.data_value) max_values ,
  min(r.data_value) min_values 
from task_values r,parameters p
where p.id =r.parameter_id
group by p.process_instance_id,p.id
union
select p.id,p.process_instance_id,r.parameter_id,
    p.parameter_type_id, p.parameter_role_id,
        sum(null) avg_values,
  sum(null) stddev_values,
  count(r.id) num_values ,
  count(distinct r.data_content) num_unique ,
  min(data_content) max_values ,
  max(data_content) min_values 
from task_texts r,parameters p
where p.id =r.parameter_id
group by p.process_instance_id,p.id
union
select p.id,p.process_instance_id,r.parameter_id,
    p.parameter_type_id, p.parameter_role_id,
    sum(null) avg_values,
  sum(null) stddev_values,
  count(r.id) num_values ,
  count(distinct r.data_name) num_unique ,
  max(r.data_name) max_values ,
  min(r.data_name) min_values 
from task_references r,parameters p
where p.id =r.parameter_id
group by p.process_instance_id,p.id
SQL

#-----------task_statistics---------------------------------------
   
    execute <<SQL
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

#-----------task_result_values---------------------------------------
  
  execute <<SQL
      create view task_result_values as
      select ti.id id,
             tc.row_no,
             p.column_no,
             tc.task_id,
             p.parameter_context_id,
             tr.task_context_id,
             tr.parameter_id reference_parameter_id,
             tr.data_element_id,
             tr.data_type,
             tr.data_id,
             tr.data_name subject,
             ti.parameter_id,
             pc.protocol_version_id,
             pc.label,
             tc.label row_label,
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
SQL

#-----------task_results_texts---------------------------------------
  execute <<SQL
      create view task_result_texts as
      select ti.id id,
             tc.row_no,
             p.column_no,
             tc.task_id,
             p.parameter_context_id,
             tr.task_context_id,
             tr.parameter_id reference_parameter_id,
             tr.data_element_id,
             tr.data_type,
             tr.data_id,
             tr.data_name subject,
             ti.parameter_id,
             pc.protocol_version_id,
             pc.label,
             tc.label row_label,
             p.name parameter_name,
             ti.data_content data_value,
             ti.created_by,
             ti.created_at,
             ti.updated_by,
             ti.updated_at
      from parameter_contexts pc,
           parameters p,
           task_contexts tc,
           task_references tr,
           task_texts ti
      where  tc.id = tr.task_context_id 
      and   ti.task_context_id = tc.id 
      and   p.id = ti.parameter_id
      and   pc.id = tc.parameter_context_id   
SQL

#----------------task_results------------------------------------------------
 execute <<SQL
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
SQL

#----------------compound_results------------------------------------------------
  execute <<SQL
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
SQL

#------------ parameter_facts -------------------------------------
 execute <<SQL
create view parameter_facts as 
select p.id,
       p.name parameter_name,
       sp.name study_parameter_name,
       pt.name parameter_type_name,
       t.name  type_name,
       e.name  element_name,
       f.name  format_name,
       r.name  role_name,
       pv.name version_label,
       pv.version version,
       pd.name protocol_name,
       s.name study_name,
       pc.label context_label,
       pc.default_count context_count,
       pc.level_no context_level,
       p.column_no,
       p.sequence_num,
       p.description,
       p.mandatory,
       p.default_value,
       p.display_unit,
       p.parameter_type_id,
       p.parameter_role_id,
       p.parameter_context_id,
       pc.parent_id parent_context_id,
       p.data_element_id,
       p.qualifier_style,
       p.data_type_id,
       p.data_format_id
from study_parameters sp
inner join parameters  p        on p.study_parameter_id = sp.id
inner join parameter_types pt   on pt.id = p.parameter_type_id
inner join data_types t         on t.id = p.data_type_id
inner join parameter_contexts pc on pc.id = p.parameter_context_id
inner join protocol_versions pv on pv.id = p.protocol_version_id
inner join study_protocols pd   on pd.id = pv.study_protocol_id
inner join parameter_roles r    on r.id = p.parameter_role_id
inner join studies s            on s.id = sp.study_id
left outer join data_elements e on e.id = p.data_element_id
left outer join data_formats f  on f.id = p.data_format_id
order by s.id,pd.id,pv.id,p.column_no 
SQL

#----------------task_value_histograms------------------------------------------------
 execute <<SQL
create view task_value_histograms as 
select 
     z.id,
     z.parameter_id,
     z.value_avg,
     z.value_min,
     z.value_max,
     z.value_stddev,
     z.value_count,
     count(case when v.data_value between z.value_min and zone1 then v.data_value else null end) zone1,
     count(case when v.data_value between z.zone1 and z.zone2 then v.data_value else null end) zone2,
     count(case when v.data_value between z.zone2 and z.zone3 then v.data_value else null end) zone3,
     count(case when v.data_value between z.zone3 and z.zone4 then v.data_value else null end) zone4,
     count(case when v.data_value between z.zone4 and z.zone5 then v.data_value else null end) zone5,
     count(case when v.data_value between z.zone5 and z.zone6 then v.data_value else null end) zone6,
     count(case when v.data_value between z.zone6 and z.zone7 then v.data_value else null end) zone7,
     count(case when v.data_value between z.zone7 and z.zone8 then v.data_value else null end) zone8,
     count(case when v.data_value between z.zone8 and z.zone9 then v.data_value else null end) zone9,
     count(case when v.data_value between z.zone9 and z.value_max then v.data_value else null end) zone10,
     z.first_updated_at,
     z.last_updated_at
from (
     select parameter_id id,
       task_id,
       parameter_id,
       avg(data_value) value_avg,
       stddev(data_value) value_stddev,
       count(data_value) value_count,
       min(data_value) value_min,
       0.1*(max(data_value)-min(data_value))+min(data_value) zone1,
       0.2*(max(data_value)-min(data_value))+min(data_value) zone2,
       0.3*(max(data_value)-min(data_value))+min(data_value) zone3,
       0.4*(max(data_value)-min(data_value))+min(data_value) zone4,
       0.5*(max(data_value)-min(data_value))+min(data_value) zone5,
       0.6*(max(data_value)-min(data_value))+min(data_value) zone6,
       0.7*(max(data_value)-min(data_value))+min(data_value) zone7,
       0.8*(max(data_value)-min(data_value))+min(data_value) zone8,
       0.9*(max(data_value)-min(data_value))+min(data_value) zone9,
       max(data_value) value_max,
       min(updated_at) first_updated_at,
       max(updated_at) last_updated_at
     from task_values 
     group by parameter_id
     ) z,
     task_values v
where z.parameter_id = v.parameter_id
group by parameter_id
SQL

 end

  def self.down
    execute 'drop view experiment_statistics'
  end
end
