class RecreateAssayViews < ActiveRecord::Migration
  def self.execute_ignore_error(sql)
    execute sql
  rescue  Exception => ex
     puts 'Ignoring SQL error'+ex.message    
  end

  def self.up

  create_view "assay_statistics", "
select p.assay_parameter_id id,
       p.assay_parameter_id assay_parameter_id,
       e.assay_id assay_id,
       p.parameter_role_id parameter_role_id,
       p.parameter_type_id parameter_type_id,
       p.data_type_id data_type_id,
       avg(r.data_value) avg_values,
       sum(null) stddev_values,
       count(r.data_value) num_values,
       count(distinct r.data_value) num_unique,
       max(r.data_value) max_values,
       min(r.data_value) min_values
  from task_values r, parameters p, tasks t, experiments e
 where p.id = r.parameter_id
   and t.id = r.task_id
   and e.id = t.experiment_id
   and p.assay_parameter_id is not null
 group by e.assay_id,
          p.data_type_id,
          p.parameter_role_id,
          p.parameter_type_id,
          p.assay_parameter_id
union
select p.assay_parameter_id id,
       p.assay_parameter_id assay_parameter_id,
       e.assay_id assay_id,
       p.parameter_role_id parameter_role_id,
       p.parameter_type_id parameter_type_id,
       p.data_type_id data_type_id,
       sum(null) avg_values,
       sum(null) stddev_values,
       count(r.id) num_values,
       count(distinct r.data_content) num_unique,
       sum(null) max_values,
       sum(null) min_values
  from task_texts r, parameters p, tasks t, experiments e
 where p.id = r.parameter_id
   and t.id = r.task_id
   and e.id = t.experiment_id
   and p.assay_parameter_id is not null
 group by e.assay_id,
          p.data_type_id,
          p.parameter_role_id,
          p.parameter_type_id,
          p.assay_parameter_id
union
select p.assay_parameter_id id,
       p.assay_parameter_id assay_parameter_id,
       e.assay_id assay_id,
       p.parameter_role_id parameter_role_id,
       p.parameter_type_id parameter_type_id,
       p.data_type_id data_type_id,
       sum(null) avg_values,
       sum(null) stddev_values,
       count(r.id) num_values,
       count(distinct r.data_name) num_unique,
       max(r.data_id) max_values,
       min(r.data_id) min_values
  from task_references r, parameters p, tasks t, experiments e
 where p.id = r.parameter_id
   and t.id = r.task_id
   and e.id = t.experiment_id
   and p.assay_parameter_id is not null
 group by e.assay_id,
          p.data_type_id,
          p.parameter_role_id,
          p.parameter_type_id,
          p.assay_parameter_id", :force => true do |v|
    v.column :id
    v.column :assay_parameter_id
    v.column :assay_id
    v.column :parameter_role_id
    v.column :parameter_type_id
    v.column :data_type_id
    v.column :avg_values
    v.column :stddev_values
    v.column :num_values
    v.column :num_unique
    v.column :max_values
    v.column :min_values
  end

  create_view "compound_results", "
  select ti.id       id,
         tc.row_no   row_no,
         p.column_no column_no,
         tc.task_id  task_id,
         p.parameter_context_id parameter_context_id,
         tr.task_context_id task_context_id,
         tr.data_element_id data_element_id,
         tr.parameter_id compound_parameter_id,
         tr.data_id      compound_id,
         tr.data_name    compound_name,
         pc.protocol_version_id protocol_version_id,
         pc.label label,
         tc.label row_label,
         ti.parameter_id parameter_id,
         p.name parameter_name,
         ti.data_value  data_value,
         ti.storage_unit data_unit,
         ti.created_by_user_id created_by_user_id,
         ti.created_at created_at,
         ti.updated_by_user_id updated_by_user_id,
         ti.updated_at updated_at
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
    ", :force => true do |v|
    v.column :id
    v.column :row_no
    v.column :column_no
    v.column :task_id
    v.column :parameter_context_id
    v.column :task_context_id
    v.column :data_element_id
    v.column :compound_parameter_id
    v.column :compound_id
    v.column :compound_name
    v.column :protocol_version_id
    v.column :label
    v.column :row_label
    v.column :parameter_id
    v.column :parameter_name
    v.column :data_value
    v.column :created_by_user_id
    v.column :created_at
    v.column :updated_by_user_id
    v.column :updated_at
  end

  create_view "experiment_statistics", "
select  t.experiment_id*1000000+p.assay_parameter_id id,
        t.experiment_id,
        p.assay_parameter_id,
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
and   p.assay_parameter_id is not null
group by t.experiment_id,
         p.parameter_role_id,
         p.parameter_type_id,
         p.data_type_id,
	 p.assay_parameter_id
union
select t.experiment_id*1000000+p.assay_parameter_id id,
       t.experiment_id,
       p.assay_parameter_id,
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
and   p.assay_parameter_id is not null
and   t.id =r.task_id
group by t.experiment_id,
         p.parameter_role_id,
         p.parameter_type_id,
         p.data_type_id,
	 p.assay_parameter_id
union
select t.experiment_id*1000000+p.assay_parameter_id id,
       t.experiment_id,
       p.assay_parameter_id,
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
and   p.assay_parameter_id is not null
and   t.id =r.task_id
group by t.experiment_id,
         p.parameter_role_id,
         p.parameter_type_id,
         p.data_type_id,
	 p.assay_parameter_id
    ", :force => true do |v|
    v.column :id
    v.column :experiment_id
    v.column :assay_parameter_id
    v.column :parameter_role_id
    v.column :parameter_type_id
    v.column :data_type_id
    v.column :avg_values
    v.column :stddev_values
    v.column :num_values
    v.column :num_unique
    v.column :max_values
    v.column :min_values
  end

  create_view "process_statistics", "
select p.id,
       p.assay_parameter_id,
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
 group by p.assay_parameter_id,
          p.protocol_version_id,
          r.parameter_id,
          p.parameter_role_id,
          p.parameter_type_id,
          p.id
union
select p.id,
       p.assay_parameter_id,
       p.protocol_version_id,
       r.parameter_id,
       p.parameter_role_id,
       p.parameter_type_id,
       sum(null) avg_values,
       sum(null) stddev_values,
       count(r.id) num_values,
       count(distinct r.data_content) num_unique,
       sum(null) max_values,
       sum(null) min_values
  from task_texts r, parameters p
 where p.id = r.parameter_id
 group by p.assay_parameter_id,
          p.protocol_version_id,
          p.parameter_role_id,
          p.parameter_type_id,
          r.parameter_id,
          p.id
union
select p.id,
       p.assay_parameter_id,
       p.protocol_version_id,
       r.parameter_id,
       p.parameter_role_id,
       p.parameter_type_id,
       sum(null) avg_values,
       sum(null) stddev_values,
       count(r.id) num_values,
       count(distinct r.data_name) num_unique,
       max(r.data_id) max_values,
       min(r.data_id) min_values
  from task_references r, parameters p
 where p.id = r.parameter_id
 group by p.assay_parameter_id,
          p.protocol_version_id,
          r.parameter_id,
          p.parameter_role_id,
          p.parameter_type_id,
          p.id    ", :force => true do |v|
    v.column :id
    v.column :assay_parameter_id
    v.column :protocol_version_id
    v.column :parameter_id
    v.column :parameter_role_id
    v.column :parameter_type_id
    v.column :avg_values
    v.column :stddev_values
    v.column :num_values
    v.column :num_unique
    v.column :max_values
    v.column :min_values
  end

  create_view "queue_result_texts", "
  select ti.id id,
         tc.row_no,
         p.column_no,
         tc.task_id,
         qi.id queue_item_id,
         qi.request_service_id,
         qi.assay_queue_id,
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
         ti.created_by_user_id,
         ti.created_at,
         ti.updated_by_user_id,
         ti.updated_at
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
  and    qi.data_name = tr.data_name    ", :force => true do |v|
    v.column :id
    v.column :row_no
    v.column :column_no
    v.column :task_id
    v.column :queue_item_id
    v.column :request_service_id
    v.column :assay_queue_id
    v.column :parameter_context_id
    v.column :task_context_id
    v.column :reference_parameter_id
    v.column :data_element_id
    v.column :data_type
    v.column :data_id
    v.column :subject
    v.column :parameter_id
    v.column :protocol_version_id
    v.column :label
    v.column :row_label
    v.column :parameter_name
    v.column :data_value
    v.column :created_by_user_id
    v.column :created_at
    v.column :updated_by_user_id
    v.column :updated_at
  end

  create_view "queue_result_values", "
  select ti.id id,
         tc.row_no,
         p.column_no,
         tc.task_id,
         qi.id queue_item_id,
         qi.request_service_id,
         qi.assay_queue_id,
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
         ti.created_by_user_id,
         ti.created_at,
         ti.updated_by_user_id,
         ti.updated_at
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
  and    qi.data_name = tr.data_name    ", :force => true do |v|
    v.column :id
    v.column :row_no
    v.column :column_no
    v.column :task_id
    v.column :queue_item_id
    v.column :request_service_id
    v.column :assay_queue_id
    v.column :parameter_context_id
    v.column :task_context_id
    v.column :reference_parameter_id
    v.column :data_element_id
    v.column :data_type
    v.column :data_id
    v.column :subject
    v.column :parameter_id
    v.column :protocol_version_id
    v.column :label
    v.column :row_label
    v.column :parameter_name
    v.column :data_value
    v.column :created_by_user_id
    v.column :created_at
    v.column :updated_by_user_id
    v.column :updated_at
  end

  create_view "queue_results", "
    select ti.id id,
         tc.row_no,
         p.column_no,
         tc.task_id,
         qi.id queue_item_id,
         qi.request_service_id,
         qi.assay_queue_id,
         qi.requested_by_user_id,
         qi.assigned_to_user_id,
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
         ti.created_by_user_id,
         ti.created_at,
         ti.updated_by_user_id,
         ti.updated_at
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
  select ti.id id,
         tc.row_no,
         p.column_no,
         tc.task_id,
         qi.id queue_item_id,
         qi.request_service_id,
         qi.assay_queue_id,
         qi.requested_by_user_id,
         qi.assigned_to_user_id,
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
         to_char(ti.data_value),
         ti.created_by_user_id,
         ti.created_at,
         ti.updated_by_user_id,
         ti.updated_at
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
    ", :force => true do |v|
    v.column :id
    v.column :row_no
    v.column :column_no
    v.column :task_id
    v.column :queue_item_id
    v.column :request_service_id
    v.column :assay_queue_id
    v.column :requested_by_user_id
    v.column :assigned_to_user_id
    v.column :parameter_context_id
    v.column :task_context_id
    v.column :reference_parameter_id
    v.column :data_element_id
    v.column :data_type
    v.column :data_id
    v.column :subject
    v.column :parameter_id
    v.column :protocol_version_id
    v.column :label
    v.column :row_label
    v.column :parameter_name
    v.column :data_value
    v.column :created_by_user_id
    v.column :created_at
    v.column :updated_by_user_id
    v.column :updated_at
  end

  create_view "task_result_texts", "
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
         ti.created_by_user_id,
         ti.created_at,
         ti.updated_by_user_id,
         ti.updated_at
  from parameter_contexts pc,
       parameters p,
       task_contexts tc,
       task_references tr,
       task_texts ti
  where  tc.id = tr.task_context_id 
  and   ti.task_context_id = tc.id 
  and   p.id = ti.parameter_id
  and   pc.id = tc.parameter_context_id", :force => true do |v|
    v.column :id
    v.column :row_no
    v.column :column_no
    v.column :task_id
    v.column :parameter_context_id
    v.column :task_context_id
    v.column :reference_parameter_id
    v.column :data_element_id
    v.column :data_type
    v.column :data_id
    v.column :subject
    v.column :parameter_id
    v.column :protocol_version_id
    v.column :label
    v.column :row_label
    v.column :parameter_name
    v.column :data_value
    v.column :created_by_user_id
    v.column :created_at
    v.column :updated_by_user_id
    v.column :updated_at
  end

  create_view "task_result_values", "
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
         ti.created_by_USER_ID,
         ti.created_at,
         ti.updated_by_USER_ID,
         ti.updated_at
  from parameter_contexts pc,
       parameters p,
       task_contexts tc,
       task_references tr,
       task_values ti
  where  tc.id = tr.task_context_id 
  and   ti.task_context_id = tc.id 
  and   p.id = ti.parameter_id
  and   pc.id = tc.parameter_context_id    ", :force => true do |v|
    v.column :id
    v.column :row_no
    v.column :column_no
    v.column :task_id
    v.column :parameter_context_id
    v.column :task_context_id
    v.column :reference_parameter_id
    v.column :data_element_id
    v.column :data_type
    v.column :data_id
    v.column :subject
    v.column :parameter_id
    v.column :protocol_version_id
    v.column :label
    v.column :row_label
    v.column :parameter_name
    v.column :data_value
    v.column :created_by_USER_ID
    v.column :created_at
    v.column :updated_by_USER_ID
    v.column :updated_at
  end

  create_view "task_results", "
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
         to_char(ti.data_value) data_value,
         ti.created_by_user_id,
         ti.created_at,
         ti.updated_by_user_id,
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
         ti.created_by_user_id,
         ti.created_at,
         ti.updated_by_user_id,
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
         ti.created_by_user_id,
         ti.created_at,
         ti.updated_by_user_id,
         ti.updated_at
  from parameter_contexts pc,
       parameters p,
       task_contexts tc,
       task_references ti
  where ti.task_context_id = tc.id 
  and   p.id  = ti.parameter_id
  and   pc.id = tc.parameter_context_id     ", :force => true do |v|
    v.column :id
    v.column :protocol_version_id
    v.column :parameter_context_id
    v.column :label
    v.column :row_label
    v.column :row_no
    v.column :column_no
    v.column :task_id
    v.column :parameter_id
    v.column :parameter_name
    v.column :data_value
    v.column :created_by_user_id
    v.column :created_at
    v.column :updated_by_user_id
    v.column :updated_at
  end

  create_view "task_statistics", "
select (r.task_id*100000+r.parameter_id) id,r.task_id,r.parameter_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id,
    avg(r.data_value) avg_values,
	stddev(r.data_value) stddev_values,
 	count(r.data_value) num_values ,
 	count(distinct r.data_value) num_unique ,
	max(r.data_value) max_values ,
	min(r.data_value) min_values 
from task_values r,parameters p
where p.id =r.parameter_id
group by r.parameter_id,r.task_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id
union
select (r.task_id*100000+r.parameter_id) id,r.task_id,r.parameter_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id,
    sum(null) avg_values,
	sum(null) stddev_values,
 	count(r.id) num_values ,
 	count(distinct r.data_content) num_unique ,
	sum(null) max_values ,
	sum(null) min_values 
from task_texts r,parameters p
where p.id =r.parameter_id
group by r.parameter_id,r.task_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id
union
select (r.task_id*100000+r.parameter_id) id,r.task_id,r.parameter_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id,
    sum(null) avg_values,
	sum(null) stddev_values,
 	count(r.id) num_values ,
 	count(distinct r.data_name) num_unique ,
	max(r.data_id) max_values ,
	min(r.data_id) min_values 
from task_references r,parameters p
where p.id =r.parameter_id
group by r.parameter_id,r.task_id,p.parameter_role_id,p.parameter_type_id,p.data_type_id ", :force => true do |v|
    v.column :id
    v.column :task_id
    v.column :parameter_id
    v.column :parameter_role_id
    v.column :parameter_type_id
    v.column :data_type_id
    v.column :avg_values
    v.column :stddev_values
    v.column :num_values
    v.column :num_unique
    v.column :max_values
    v.column :min_values
  end

  end

  def self.down
  end
end
