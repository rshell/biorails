##
# Build a schedule for display on forms
# This consists of a collection of date boxes with linked list of items in the boxes
# 
#  schedule.first  starting date
#  schedule.last   finishing date
#  schedule.delta  size of a date period box
#  schedule.boxes[n] start date of a date box
#  schedule.items[n] array of things scheduled in period
#
# Constructors
# 
#  schedule = Schedule.tasks_in(experiment)
#  schedule = Schedule.experiments_in(study)
#  
#  Hope later to add work_on(inventory_item) etc 
#  
##
# Copyright © 2006 Robert Shell, Alces Ltd All Rights Reserved
# See license agreement for additional rights
# 


class Schedule
  attr_accessor :items
  attr_accessor :boxes
  attr_accessor :first
  attr_accessor :last
  attr_accessor :delta

  attr_accessor :model

  attr_accessor :year
  attr_accessor :month
  attr_accessor :months
  attr_accessor :zoom
  attr_accessor :date_from
  attr_accessor :date_to
 

##
#  Default initialize with a empty week,
#  
def initialize(model = Task)
   @boxes = []
   @items = []
   @first = DateTime.now
   @last  = DateTime.now + 7.days
   @delta = 1.day
   @model = model
end


# Calculate the period of the schedule 
#
def period
  return @last - @first
end

##
# Get a list of all the events in the schedule
 def events
   items.flatten
 end

##
# Get the number of time boxes in the schedule 
# each box will have a size of delta<time>
#  
 def size
   boxes.size
 end

##
# Fetch matching items from the database 
# return items or null if not configured
def find_by_user(user)
    if (@model and @date_form and @date_to)
         @items = @model.find(:all, 
         :order => "start_date, end_date", 
         :conditions => ["(created_by=?) and (((start_date>=? and start_date<=?) or (end_date>=? and end_date<=?) or (start_date<? and end_date>?)) and start_date is not null and end_date is not null)",
         user, @date_from, @date_to, @date_from, @date_to, @date_from, @date_to])
    end    
end

## 
# Featch all matching items from the database
def find_by_project(user)
    if (@model and @date_form and @date_to)
         @items = @model.find(:all, 
                              :order => "start_date, end_date", 
                              :conditions => ["(((start_date>=? and start_date<=?) or (end_date>=? and end_date<=?) or (start_date<? and end_date>?)) and start_date is not null and end_date is not null)",
                                          @date_from, @date_to, @date_from, @date_to, @date_from, @date_to])
    end    
end


##
# Fill scedule as a calendar of items 
# 
def Schedule.calendar(model,params)
    schedule = Schedule.new(model)
    if params[:year] and params[:year].to_i > 1900
      @year = params[:year].to_i
      if params[:month] and params[:month].to_i > 0 and params[:month].to_i < 13
        @month = params[:month].to_i
      end    
    end
    schedule.year ||= Date.today.year
    schedule.month ||= Date.today.month
    schedule.months = 1
    schedule.date_from = Date.civil(@year, @month, 1)
    schedule.date_to = (@date_from >> 1)-1
    # start on monday
    schedule.date_from = @date_from - (@date_from.cwday-1)
    # finish on sunday
    schedule.date_to = @date_to + (7-@date_to.cwday)  
    return schedule    
end

##
# Create a schedule for a timeline
#
def Schedule.gantt(model,params)
    schedule = Schedule.new(model)
    schedule.project = current(Project,params[:id])
    if params[:year] and params[:year].to_i >0
      schedule.year_from = params[:year].to_i
      if params[:month] and params[:month].to_i >=1 and params[:month].to_i <= 12
        schedule.month_from = params[:month].to_i
      else
        schedule.month_from = 1
      end
    else
      schedule.month_from ||= (Date.today << 1).month
      schedule.year_from ||= (Date.today << 1).year
    end
    
    schedule.zoom = (params[:zoom].to_i > 0 and params[:zoom].to_i < 5) ? params[:zoom].to_i : 2
    schedule.months = (params[:months].to_i > 0 and params[:months].to_i < 25) ? params[:months].to_i : 6
    
    schedule.date_from = Date.civil(schedule.year_from, schedule.month_from, 1)
    schedule.date_to = (schedule.date_from >> schedule.months) - 1
    return schedule    
end
##
#Build a schedule of tasks in the passed in experiment (the scientists views)  
#  
def Schedule.tasks_in(experiment)
   schedule = Schedule.new
   if experiment.tasks.size > 0
     schedule.first = experiment.start_date.at_beginning_of_day
     schedule.last = experiment.end_date + 24.hours 
     schedule.default_delta
     schedule.fill(experiment.tasks)
   end
   return schedule
end

##
#Build a schedule of experiments in study ( the project management view) 
#  
def Schedule.experiments_in(study)
   schedule = Schedule.new
   if study.experiment.size > 0
     schedule.first = study.start_date.at_beginning_of_day
     schedule.last = study.end_date + 24.hours 
     schedule.default_delta
     schedule.fill(study.experiment)
   end
   return schedule
end

##
#Build a schedule of data for subject (the analysts views) 
#  
def Schedule.results_for(subject)
   schedule = Schedule.new
   sql =<<-SQL 
      select * from task_contexts c,task_references r 
      where c.id=r.task_context_id 
      and r.data_type='#{subject.class}' and r.data_id=#{subject.id}'
SQL
   contexts = TaskContext.find_by_sql(sql)
   if contexts.size > 0
     first = TaskReference.find_by_type(subject, :order_by => 'created_at asc')
     last = TaskReference.find_by_type(subject, :order_by => 'updated_at desc')
     schedule.first = first.created_at.at_beginning_of_day
     schedule.last = last.updated_at + 24.hours 
     schedule.default_delta
     schedule.fill(contexts)
   end
   return schedule
end

def fill(values)
   from = @first
   to = @first+ @delta
   while from < @last
      @boxes << from 
      @items << values.reject{|item| item.start_date < from or item.start_date >= to}
      from += @delta 
      to += @delta
   end
end

##
# Calculate the size of a cell in the schedule
# 
def default_delta
  @delta = 1.month      
  @show_month = true
  if self.period < 4.weeks
      @show_month = false
      @delta = 1.day        
  elsif self.period < 2.month
      @delta = 1.weeks
  end
  return delta
end

end