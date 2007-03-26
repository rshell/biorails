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
group by parameter_id;
