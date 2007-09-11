##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
##
#

class Execute::ChartsController < ApplicationController

 use_authorization :reports,
                    :actions => [:list,:show,:new,:create,:edit,:update,:destroy],
                    :rights => :current_user
                      
                      
require 'scruffy'

##
# Example of javascript chart
# 
def chart
 @experiment = current(Experiment,params[:id])
 @parameter = Parameter.find(params[:parameter_id])
 
 sql =<<SQL
   select * from task_values v,tasks t 
   where t.id = v.task_id
   and t.experiment_id = #{@experiment.id}
   and v.parameter_id = #{@parameter.id}
   order by v.updated_at
SQL
 @values = TaskValue.find_by_sql(sql) 
 @from = @values[0].updated_at
end

##
# Last 100 values of this type 
# 
def resent_values
 @parameter = Parameter.find(params[:id])
 
 sql =<<SQL
   select * from task_values v,tasks t 
   where t.id = v.task_id
   and v.parameter_id = #{@parameter.id}
   order by v.updated_at desc   
SQL
 graph = Scruffy::Graph.new
 graph.value_formatter = Scruffy::Formatters::Number.new(:precision => 0)

 rows = TaskValue.find_by_sql(sql)
 values = rows.collect{|row|row.data_value.to_f}
 
  graph.title = "#{@parameter.name}"
  graph.add :line, "values ", values  
  # That's it, call render and it will return the SVG (XML) representation of our graph   
  send_data( graph.render(:width => 300, :as => 'PNG') , 
            :disposition => 'inline', 
            :type => 'image/png', 
            :filename => "values-#{@parameter.id}.png")                        
end

##
# Tread charts for a parameter over time
#
def test
 logger.info "plot #{params[:id]}"
 graph = Scruffy::Graph.new
 graph.value_formatter = Scruffy::Formatters::Number.new(:precision => 0)

 plots = (1...100).collect{|row|[row,row*2]}
 vals = (1...100).collect{|row|[row,row]}
  graph.title = "test"
  graph.add :plot, "mins ", plots  
  graph.add :plot, "avg ", vals  
#  graph.add :line, "max ", maxs   
  # That's it, call render and it will return the SVG (XML) representation of our graph   
  send_data( graph.render(:width => 800, :as => 'PNG') , 
            :disposition => 'inline', 
            :type => 'image/png', 
            :filename => "plot.png")                        
end

##mins
# Tread charts for a parameter over time
#
def trend_by_hour
 @parameter = Parameter.find(params[:id])
 sql =<<SQL
    select parameter_id,
           avg(data_value)    value_avg,
           stddev(data_value) value_stddev,
           count(data_value) value_count,
           min(data_value) value_min,
           max(data_value) value_max,
           hour(updated_at) hours 
    from task_values
    where parameter_id = #{@parameter.id} 
    group by hour(updated_at) 
SQL

 graph = Scruffy::Graph.new
 graph.value_formatter = Scruffy::Formatters::Number.new(:precision => 0)

 rows = TaskValue.find_by_sql(sql)

 hours = rows.collect{|row|row.hours}
 mins = rows.collect{|row|row.value_min.to_f}
 maxs = rows.collect{|row|row.value_max.to_f}
 avgs = rows.collect{|row|row.value_avg.to_f}
 stds = rows.collect{|row|row.value_stddev.to_f}
 nums = rows.collect{|row|row.value_count.to_i}
 
  graph.point_markers = hours
  graph.title = "#{@parameter.name}"
  graph.add :line, "mins ", mins  
  graph.add :line, "avg ", avgs  
  graph.add :line, "max ", maxs   
  # That's it, call render and it will return the SVG (XML) representation of our graph   
  send_data( graph.render(:width => 300, :as => 'PNG') , 
            :disposition => 'inline', 
            :type => 'image/png', 
            :filename => "histogram-#{@parameter.id}.png")                        
end


##
# Tread charts for a parameter over tasks.
#
def trend_by_task
 @parameter = Parameter.find(params[:id])
 sql =<<SQL
  select v.parameter_id,
        t.id,
	t.name,
	t.experiment_id,
        avg(v.data_value)    value_avg,
        stddev(v.data_value) value_stddev,
        count(v.data_value) value_count,
        min(v.data_value) value_min,
        max(v.data_value) value_max
    from task_values v, tasks t
    where parameter_id = #{@parameter.id} 
    group by 
        v.parameter_id,
        t.id,
	t.name,
	t.experiment_id
SQL

 graph = Scruffy::Graph.new
 graph.value_formatter = Scruffy::Formatters::Number.new(:precision => 0)

 rows = TaskValue.find_by_sql(sql)

 names = rows.collect{|row|row.name}
 mins = rows.collect{|row|row.value_min.to_f}
 maxs = rows.collect{|row|row.value_max.to_f}
 avgs = rows.collect{|row|row.value_avg.to_f}
 stds = rows.collect{|row|row.value_stddev.to_f}
 nums = rows.collect{|row|row.value_count.to_i}
 
  graph.point_markers = names
  graph.title = "#{@parameter.name}"
  graph.add :line, "mins ", mins  
  graph.add :line, "avg ", avgs  
  graph.add :line, "max ", maxs   
  # That's it, call render and it will return the SVG (XML) representation of our graph   
  send_data( graph.render(:width => 800, :as => 'PNG') , 
            :disposition => 'inline', 
            :type => 'image/png', 
            :filename => "histogram-#{@parameter.id}.png")                        
end


##
# Create a histogram for a parameter based on 10 value zones.
# Once have function ploting should add a plot of the normal curve with mean and sd values.
# 
# Have written query in ANSI SQL so should work in both oracle and MySQL. There are better 
# ways in oracle but thats another version!.
# 
def histogram
 @parameter = Parameter.find(params[:id])

 sql =<<SQL
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
     where parameter_id = #{@parameter.id}
     group by parameter_id
     ) z,
     task_values v
  where z.parameter_id = v.parameter_id
  and z.parameter_id = #{@parameter.id}
  group by z.parameter_id;
SQL
 graph = Scruffy::Graph.new

# Tell scruffy how we want the values to be formatted (number, currency, etc.)
 graph.value_formatter = Scruffy::Formatters::Number.new(:precision => 0)

 for row in TaskValue.find_by_sql(sql) do
    
    min = row.value_min.to_f
    max = row.value_max.to_f
    avg = row.value_avg.to_f
    stddev = row.value_stddev.to_f
    num = row.value_count.to_i    
    range = row.value_max.to_f - row.value_min.to_f
    
    labels = [min,    "" , "" , "" , "" , "" , "" , "" , "" , "",   max]

    values = [row.zone1.to_i, row.zone2.to_i, row.zone3.to_i, row.zone4.to_i, row.zone5.to_i,
              row.zone6.to_i, row.zone7.to_i, row.zone8.to_i, row.zone9.to_i, row.zone10.to_i]
    graph.point_markers = labels
    graph.title = "#{@parameter.name}"
    graph.add :bar, "mean=#{avg} sd=#{stddev} (#{num}) ", values  
 end 
  # That's it, call render and it will return the SVG (XML) representation of our graph   
 send_data( graph.render(:width => 300,:min_value =>0.0, :as => 'PNG') , 
            :disposition => 'inline', 
            :type => 'image/png', 
            :filename => "histogram-#{@parameter.id}.png")                        
end
 
end
